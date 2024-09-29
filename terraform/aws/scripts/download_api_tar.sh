#!/bin/bash

SFTP_USER=user
SFTP_INSTANCE_IP=`cat /var/sftp_meta/sftp_ip`
WEB_ARCHIVE_NAME=class_schedule.war
TOMCAT_PATH=/usr/share/tomcat9
TARGET_TAR_PATH=$TOMCAT_PATH/webapps


echo "Connecting to $SFTP_INSTANCE_IP"

ssh-keyscan -H $SFTP_INSTANCE_IP >> ~/.ssh/known_hosts

sftp -i /var/sftp_meta/sftp_key $SFTP_USER@$SFTP_INSTANCE_IP << EOF > /dev/null
cd data
get $WEB_ARCHIVE_NAME
get tomcat-users.xml
EOF

if [[ -f "$WEB_ARCHIVE_NAME" && -s "$WEB_ARCHIVE_NAME" ]]; then
    echo "'$WEB_ARCHIVE_NAME' has been downloaded successfully"
else
    echo "Failed to download '$WEB_ARCHIVE_NAME'"
    exit
fi

mv $WEB_ARCHIVE_NAME $TARGET_TAR_PATH/$WEB_ARCHIVE_NAME
mv tomcat-users.xml $TOMCAT_PATH/conf/tomcat-users.xml

chown -R root:tomcat $TOMCAT_PATH
chmod -R 777 $TOMCAT_PATH
