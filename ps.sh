#!/bin/bash

frmt="%-15s%-15s%-30s\t%-20s\n"

printf "$frmt" PID USER COMM STAT

for proc in `ls /proc/ | egrep "^[0-9]" | sort -n`
do

    if [[ -f /proc/$proc/status ]]
        then
        PID=$proc
    COMM=`cat /proc/$proc/cmdline`
    if  [[ -z "$COMM" ]]
        then
        COMM="[`awk '/Name/{print $2}' /proc/$proc/status`]"
    else
        COMM=`cat /proc/$proc/cmdline`
    fi

    User=`awk '/Uid/{print $2}' /proc/$proc/status`
    Stat=`cat /proc/$proc/status | awk '/State/{print $2}'`
    if [[ User -eq 0 ]]
       then
       UserName='root'
    else
       UserName=`grep $User /etc/passwd | awk -F ":" '{print $1}'`
    fi
    printf "$frmt" $PID $UserName "$COMM" $Stat
    fi
done
