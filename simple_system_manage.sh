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
#!/usr/bin/bash

# utility functions
INFO() {
/usr/bin/echo -e "\e[104m\e[97m[INFO]\e[49m\e[39m $*"
}

WARNING() {
/usr/bin/echo >&2 -e "\e[101m\e[97m[WARNING]\e[49m\e[39m $*"
}

ERROR() {
/usr/bin/echo >&2 -e "\e[101m\e[97m[ERROR]\e[49m\e[39m $*"
}

menu(){
cat <<-EOF
##########################################
        t.system top all
        d.filesystem mount
        m.memory
        u.system load
        q.exit
##########################################
EOF
}
while :
do
#execute function menu
menu
read -p "Please input:" action
case "$action" in
t)
        top -cbn 1
        ;;
d)
        df -Th
        ;;
m)
        free -m
        ;;
u)
        uptime
        ;;
q)
        INFO "exit,bye"
        exit 1
        ;;
*)
        ERROR "error"
esac
done
