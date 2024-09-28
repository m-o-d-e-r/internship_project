#!/bin/bash

echo -n "[Enter remote sftp IP] > "
read REMOTE_SFTP_IP

rsync -urltv --delete -e "ssh -i keys/id_ed25519 -q" ./artifacts/ sftpuser@$REMOTE_SFTP_IP:/var/sftp/data/
