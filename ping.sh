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
     if ping "$ip" -c 1 &> /dev/null
     then 
         echo "$ip is alive"
     else 
         echo "$ip is unreachable"
     fi
done
