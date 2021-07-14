#!/usr/bin/bash
#
#********************************************************************
#Author:             LiuFei
#Email：             laufei90@163.com
#Date：              2021-07-10
#FileName：          system_manage.sh
#Description：       The purpose of the script is for system_manage.
#Copyright (C)：     2021 All rights reserved
#********************************************************************
#
source ./simple_system_manage_function.sh

menu(){
cat <<-EOF
 $S
 1.system Details             11.recent 3 reboot events
 2.system uptime              12.recent 3 shutdown events
 3.read-only file systems     13.top 5 Memory & CPU consumed
 4.mounted file systems
 5.Check disk usage
 6.zombie processes
 7.Check Inode usage
 8.Check SWAP
 9.Check Processor
 10.Check load average
 q.exit
 $S
EOF
}

while :
do
#execute function menu
menu
if read -t 30 -p "Please input:" action
then
case "$action" in
1)
     #--------Print Operating System Details--------#
     hostname -f &>/dev/null && printf "Hostname : $(hostname -f)" || printf "Hostname : $(hostname -s)"
     echo -en "\nOperating System : "
     [ -f /etc/os-release ] && echo "$(egrep -w "NAME|VERSION" /etc/os-release | awk -F= '{ print $2 }' | sed 's/"//g')" || cat /etc/system-release
     echo -e "Kernel Version :" "$(uname -r)"
     printf "OS Architecture :""$(arch | grep x86_64 &>/dev/null)" && printf " 64 Bit OS\n" || printf " 32 Bit OS\n"
     ;;
2)
     #--------Print system uptime-------#
     UPTIME=$(uptime)
     echo -en "System Uptime : "
     echo $UPTIME | grep day &>/dev/null
     if [ $? != 0 ]; then
        echo $UPTIME | grep -w min &>/dev/null && echo -en "$(echo $UPTIME | awk '{print $2" by "$3}' | sed -e 's/,.*//g') minutes" ||
         echo -en "$(echo $UPTIME | awk '{print $2" by "$3" "$4}' | sed -e 's/,.*//g') hours"
     else
         echo -en $(echo $UPTIME | awk '{print $2" by "$3" "$4" "$5" hours"}' | sed -e 's/,//g')
     fi
         echo -e "\nCurrent System Date & Time : "$(date +%c)
     ;;
3)
      #--------Check for any read-only file systems--------#
     echo -e "\nChecking For Read-only File System[s]"
     echo -e "$D"
     echo "$MOUNT" | grep -w \(ro\) && echo -e "\n.....Read Only file system[s] found" || echo -e ".....No read-only file system[s] found. "
     ;;
4)
     #--------Check for currently mounted file systems--------#
     echo -e "\n\nChecking For Currently Mounted File System[s]"
     echo -e "$D$D"
     echo "$MOUNT" | column -t
     ;;

5)
    #--------Check disk usage on all mounted file systems--------#
    echo -e "\n\nChecking For Disk Usage On Mounted File System[s]"
    echo -e "$D$D"
    echo -e "( 0-85% = OK/HEALTHY,  85-95% = WARNING,  95-100% = CRITICAL )"
    echo -e "$D$D"
    echo -e "Mounted File System[s] Utilization (Percentage Used):\n"

    COL1=$(echo "$FS_USAGE" | awk '{print $1 " "$7}')
    COL2=$(echo "$FS_USAGE" | awk '{print $6}' | sed -e 's/%//g')

    for i in $(echo "$COL2"); do
    {
      if [ $i -ge 95 ]; then
         COL3="$(echo -e $i"% $CRITICAL\n$COL3")"
      elif [[ $i -ge 85 && $i -lt 95 ]]; then
         COL3="$(echo -e $i"% $WARNING\n$COL3")"
      else
          COL3="$(echo -e $i"% $INFO\n$COL3")"
    fi
   }
   done
   COL3=$(echo "$COL3" | sort -k1n)
   paste <(echo "$COL1") <(echo "$COL3") -d' ' | column -t
   ;;
6)
   #--------Check for any zombie processes--------#
   echo -e "\n\nChecking For Zombie Processes"
   echo -e "$D"
   ps -eo stat | grep -w Z 1>&2 >/dev/null
   if [ $? == 0 ]; then
   echo -e "Number of zombie process on the system are :" "$(ps -eo stat | grep -w Z | wc -l)"
   echo -e "\n  Details of each zombie processes found   "
   echo -e "  $D"
   ZPROC=$(ps -eo stat,pid | grep -w Z | awk '{print $2}')
   for i in $(echo "$ZPROC"); do
     ps -o pid,ppid,user,stat,args -p $i
   done
   else
     echo -e "No zombie processes found on the system."
   fi
   ;;

7)
   #--------Check Inode usage--------#
   echo -e "\n\nChecking For INode Usage"
   echo -e "$D$D"
   echo -e "( 0-85% = OK/HEALTHY,  85-95% = WARNING,  95-100% = CRITICAL )"
   echo -e "$D$D"
   echo -e "INode Utilization (Percentage Used):\n"

   COL11=$(echo "$IUSAGE" | awk '{print $1" "$7}')
   COL22=$(echo "$IUSAGE" | awk '{print $6}' | sed -e 's/%//g')

  for i in $(echo "$COL22"); do
    {
    if [[ $i = *[[:digit:]]* ]]; then
      {
        if [ $i -ge 95 ]; then
          COL33="$(echo -e $i"% $CRITICAL\n$COL33")"
        elif [[ $i -ge 85 && $i -lt 95 ]]; then
          COL33="$(echo -e $i"% $WARNING\n$COL33")"
        else
          COL33="$(echo -e $i"% $INFO\n$COL33")"
        fi
      }
    else
      COL33="$(echo -e $i"% (Inode Percentage details not available)\n$COL33")"
    fi
  }
  done

   COL33=$(echo "$COL33" | sort -k1n)
   paste <(echo "$COL11") <(echo "$COL33") -d' ' | column -t
   ;;
8)
   #--------Check for SWAP Utilization--------#
   echo -e "\n\nChecking SWAP Details"
   echo -e "$D"
   echo -e "Total Swap Memory in MiB : "$(grep -w SwapTotal /proc/meminfo | awk '{print $2/1024}')", in GiB : " \
   $(grep -w SwapTotal /proc/meminfo | awk '{print $2/1024/1024}')
   echo -e "Swap Free Memory in MiB : "$(grep -w SwapFree /proc/meminfo | awk '{print $2/1024}')", in GiB : " \
   $(grep -w SwapFree /proc/meminfo | awk '{print $2/1024/1024}')

   ;;
9)
   #--------Check for Processor Utilization (current data)--------#
   echo -e "\n\nChecking For Processor Utilization"
   echo -e "$D"
   echo -e "\nCurrent Processor Utilization Summary :\n"
   mpstat | tail -2
   ;;

10)
   #--------Check for load average (current data)--------#
   echo -e "\n\nChecking For Load Average"
   echo -e "$D"
   echo -e "Current Load Average : $(uptime | grep -o "load average.*" | awk '{print $3" " $4" " $5}')"
   ;;

11)
   #------Print most recent 3 reboot events if available----#
   echo -e "\n\nMost Recent 3 Reboot Events"
   echo -e "$D$D"
   last -x 2>/dev/null | grep reboot 1>/dev/null && /usr/bin/last -x 2>/dev/null | grep reboot | head -3 ||
   echo -e "No reboot events are recorded."
   ;;

12)
   #------Print most recent 3 shutdown events if available-----#
   echo -e "\n\nMost Recent 3 Shutdown Events"
   echo -e "$D$D"
   last -x 2>/dev/null | grep shutdown 1>/dev/null && /usr/bin/last -x 2>/dev/null | grep shutdown | head -3 ||
   echo -e "No shutdown events are recorded."
   ;;
13)
   #--------Print top 5 Memory & CPU consumed process threads---------#
   #--------excludes current running program which is hwlist----------#
   echo -e "\n\nTop 5 Memory Resource Hog Processes"
   echo -e "$D$D"
   ps -eo pmem,pid,ppid,user,stat,args --sort=-pmem | grep -v $$ | head -6 | sed 's/$/\n/'

   echo -e "\nTop 5 CPU Resource Hog Processes"
   echo -e "$D$D"
   ps -eo pcpu,pid,ppid,user,stat,args --sort=-pcpu | grep -v $$ | head -6 | sed 's/$/\n/'
   ;;
q | Q)
   echo "exit,bye"
   exit 1
   ;;
*)
   echo "Error Input"
esac
else
   echo "wait you 30 seconds,bye!"
   exit 1
fi

done