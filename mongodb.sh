#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo -e "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo -e  "$2 is.. $R failed $N "
    else
        echo -e  "$2 is..$G Success $N "
    fi
            }
    if [ $ID -ne 0 ]
then
    echo -e "$R you are not a root user $N"
    exit 1
else
    echo "you are a root user"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied Mongodb Repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Remote Access to mongodb"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting mongodb"



