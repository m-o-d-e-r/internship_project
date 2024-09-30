#!/bin/bash

SFTP_USER=user
SFTP_INSTANCE_IP=`cat /var/schedule_meta/sftp_ip`

DUMP_NAME=dump.sql

DB_USER=super_mega_user
DB_NAME=schedule

echo "Connecting to $SFTP_INSTANCE_IP"

ssh-keyscan -H $SFTP_INSTANCE_IP >> ~/.ssh/known_hosts

sftp -i /var/schedule_meta/sftp_key $SFTP_USER@$SFTP_INSTANCE_IP << EOF > /dev/null
cd data
get $DUMP_NAME
EOF

psql -U $DB_USER -h $DB_HOST -d $DB_NAME -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
psql --set ON_ERROR_STOP=off -U $DB_USER -h $DB_HOST -d $DB_NAME -1 -f $DUMP_NAME
