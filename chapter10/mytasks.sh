#!/bin/bash
#
# Script created by Alex Callejas
# Description: This script creates and copies the data file to the users' home directory.
# Date: 18-Jun-2023
# Version: 0.1
# Version: 0.2 → Add data file validation
# Version: 1.0 → Add user creation and customization

#
# VARIABLES
#
WDIR=/root/class
LOG=$WDIR/mytasks.log
TIMESTAMP=$(date +'%m-%d-%Y %H:%M')
DATA_FILE=$WDIR/data
USER_FILE=$WDIR/users

#
# COMMANDS
#
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOG
echo "$TIMESTAMP [INFO] Start running mytasks.sh" >> $LOG
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOG
echo "$TIMESTAMP [INFO] Verify the data file" >> $LOG
if [ -f $DATA_FILE ];
then
  echo "$TIMESTAMP [OK] The data file exists" >> $LOG
else
  echo "$TIMESTAMP [INFO] Create data file" >> $LOG
  for i in passwd group shadow
  do
    cat /etc/$i >> $DATA_FILE
  done
fi
echo "$TIMESTAMP [INFO] Verify users" >> $LOG
for i in $(cat $USER_FILE)
do
  grep $i /etc/passwd 
  if [ $? == 0  ];
  then
    echo "$TIMESTAMP [WARN] The user $i exists" >> $LOG
    if [ -f /home/$i/data ];
    then
      echo "$TIMESTAMP [OK] The data file exists on $i's home directory" >> $LOG
    else
      echo "$TIMESTAMP [INFO] Copy data file on $i's home directory" >> $LOG
      cp $DATA_FILE /home/$i/
    fi
  else
    echo "$TIMESTAMP [INFO] Create the user $i" >> $LOG
    useradd $i
    echo "$TIMESTAMP [INFO] Copy data file on $i's home directory" >> $LOG
    cp $DATA_FILE /home/$i/
  fi
done
