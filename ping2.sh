#!/usr/bin/bash
#
#********************************************************************
#Author:             LiuFei
#Email：             laufei90@163.com
#Date：              2021-07-20
#FileName：          ping.sh
#Description：       The purpose of the script
#Copyright (C)：     2021 All rights reserved
#********************************************************************
#
for ip in $(cat /home/myubuntu/myshell/ips.txt)
do
    net=$(ping $ip -c 1 -w 1 | grep "已接收" | awk '{print $5}')
    if [ "$net" = "0" ]
    then 
         echo "$ip is unreachable"
    else 
         echo "$ip is alived"
    fi
done
