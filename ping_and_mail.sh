#!/usr/bin/bash
#
tv_ip=192.168.31.31
is_on_watching=0
start_time=$(date +'%Y-%m-%d %H:%M:%S')
on_time=$(date +'%Y-%m-%d %H:%M:%S')
end_time=$(date +'%Y-%m-%d %H:%M:%S')

while true
do
net=$(ping $tv_ip -c 1 -w 1 | grep "received" | awk '{print $4}')
if [ "$net" = "0" ]
then
     #unreachable
     if [ $is_on_watching = 1 ]
     then
          end_time=$(date +'%Y-%m-%d %H:%M:%S')
          echo "停止看电视时间：$end_time"
     fi
     is_on_watching=0
else
     #alived
     if [ $is_on_watching = 0 ]
     then
          start_time=$(date +'%Y-%m-%d %H:%M:%S')
          echo "开始看电视时间：$start_time"
     else
          on_time=$(date +'%Y-%m-%d %H:%M:%S')
     fi
     is_on_watching=1
fi

start_seconds=$(date --date="$start_time" +%s)
on_seconds=$(date --date="$on_time" +%s)
cal_watch_time=$((on_seconds-start_seconds))
#echo "看电视时间： ${cal_watch_time}s"
if [ $cal_watch_time -gt 3600 ]
then 
     echo "你家的娃看电视超过一个小时了,开始时间：$start_time " | mail -s "看电视提醒"  ***@qq.com
     start_time=$(date +'%Y-%m-%d %H:%M:%S')
fi

sleep 1m
done