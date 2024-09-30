#!/bin/bash

SFTP_USER=user
SFTP_INSTANCE_IP=`cat /var/schedule_meta/sftp_ip`
WEB_ARCHIVE_NAME=web.tar
TARGET_TAR_PATH=/usr/share/nginx/html


echo "Connecting to $SFTP_INSTANCE_IP"

ssh-keyscan -H $SFTP_INSTANCE_IP >> ~/.ssh/known_hosts

sftp -i /var/schedule_meta/sftp_key $SFTP_USER@$SFTP_INSTANCE_IP << EOF > /dev/null
cd data
get $WEB_ARCHIVE_NAME
EOF

if [[ -f "$WEB_ARCHIVE_NAME" && -s "$WEB_ARCHIVE_NAME" ]]; then
    echo "'$WEB_ARCHIVE_NAME' has been downloaded successfully"
else
    echo "Failed to download '$WEB_ARCHIVE_NAME'"
    exit
fi

if [[ $(file -b "$WEB_ARCHIVE_NAME") != "POSIX tar archive (GNU)" ]]; then
    echo "Invalid format of '$WEB_ARCHIVE_NAME' detected"
    exit 1
fi

sudo rm -rf /usr/share/nginx/html/*
sudo tar xf $WEB_ARCHIVE_NAME --strip-components=1 -C $TARGET_TAR_PATH

echo "Deleting '$WEB_ARCHIVE_NAME'..."

rm -f $WEB_ARCHIVE_NAME
