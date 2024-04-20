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
        exit 1
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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling Nodejs 18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing Nodejs"

id roboshop
if [$? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "creating roboshop user"
else 
    echo -e "roboshop user already exists"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downloading Catalogue Application code"

cd /app

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unzipping catalogue"

npm install &>> $LOGFILE

# use absolute path, coz catalogue.service exists there
cp /home/centos/roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "copying catalogue.service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "catalogue daemon-reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "enable catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting catalogue"

cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongo repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongodb client"

mongo --host mongodb.devopsju.online </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "loading catalogue data into mongodb"



mongo --host mongodb.devopsju.online </app/schema/catalogue.js







