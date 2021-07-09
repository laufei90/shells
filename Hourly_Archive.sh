#!/usr/bin/bash
#
#********************************************************************
#Author:             LiuFei
#Email：             laufei90@163.com
#Date：              2021-07-09
#FileName：          Hourly_Archive.sh
#Description：       The purpose of the script is to create an archive hourly
#Copyright (C)：     2021 All rights reserved
#********************************************************************
#
#utility functions
INFO() {
/usr/bin/echo -e "\e[104m\e[97m[INFO]\e[49m\e[39m $@"
}

WARNING() {
/usr/bin/echo >&2 -e "\e[101m\e[97m[WARNING]\e[49m\e[39m $@"
}

ERROR() {
/usr/bin/echo >&2 -e "\e[101m\e[97m[ERROR]\e[49m\e[39m $@"
}
#
# Set Base Archive Destination Location
#
username=$(whoami)
BASEDEST=/home/${username}/Hourly_Archive
#
# Set Configuration File
#
CONFIG_FILE=${BASEDEST}/Files_To_Backup
# Gather Current Day, Month & Time
#
DAY=$(date +%d)
MONTH=$(date +%m)
TIME=$(date +%k%M)
#
# Create Archive Destination Directory
#
mkdir -p $BASEDEST/$MONTH/$DAY
#
# Build Archive Destination File Name
#
DESTINATION=$BASEDEST/$MONTH/$DAY/archive$TIME.tar.gz
#
########## Main Script ####################

#
######### Main Script #########################
#
# Check Backup Config file exists
#
if [ -f $CONFIG_FILE ]   # Make sure the config file still exists.
then                # If it exists, do nothing but continue on.
     INFO  "$CONFIG_FILE exists"
else                # If it doesn't exist, issue error & exit script.
     echo
     ERROR "$CONFIG_FILE does not exist."
     ERROR "Backup not completed due to missing Configuration File"
     echo
     exit
fi
#
# Build the names of all the files to backup
#
FILE_NO=1               # Start on Line 1 of Config File.
exec < $CONFIG_FILE     # Redirect Std Input to name of Config File
#
read FILE_NAME          # Read 1st record
#
while [ $? -eq 0 ]      # Create list of files to backup.
do
        # Make sure the file or directory exists.
     if [ -f "$FILE_NAME" ] || [ -d "$FILE_NAME" ]
     then
          # If file exists, add its name to the list.
          FILE_LIST="$FILE_LIST $FILE_NAME"
     else
          # If file doesn't exist, issue warning
          echo
          WARNING "$FILE_NAME, does not exist."
          WARNING "Obviously, I will not include it in this archive."
          WARNING "It is listed on line $FILE_NO of the config file."
          WARNING "Continuing to build archive list..."
          echo
     fi
#
     FILE_NO=$(($FILE_NO + 1))  # Increase Line/File number by one.
     read FILE_NAME           # Read next record.
done
#
#######################################
#
# Backup the files and Compress Archive
#
INFO "Starting archive..."
echo
#
tar -czf $DESTINATION $FILE_LIST 2> /dev/null
#
INFO "Archive completed"
INFO "Resulting archive file is: $DESTINATION"
echo
#
exit