#!/bin/bash

frmt="%-10s%-10s%-80s%-20s\n"

printf "$frmt" PID USER NAME COMM

for proc in `ls  /proc/ | egrep "^[0-9]" | sort -n`
    do
    test="/proc/$proc"
        if [[ -d "$test" ]]
        then
            User=`awk '/Uid/{print $2}' /proc/$proc/status`
            comm=`cat /proc/$proc/comm | tr " " "_"` #пришлось удалить пробелы для избежания переноса строки
                if [[ User -eq 0 ]]
                then
                    UserName='root'
                else
                    UserName=`grep $User /etc/passwd | awk -F ":" '{print $1}'`
                fi
            map_files=`readlink /proc/$proc/map_files/*; readlink /proc/$proc/cwd`
            if ! [[ -z "$map_files" ]]
            then
                for num in $map_files
                do
                    printf "$frmt" $proc $UserName $num $comm
                done
            fi

        fi
done
