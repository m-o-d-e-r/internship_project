#!/bin/bash

if [[ -z "$REMOTE_SFTP_IP" ]]; then
  echo "'REMOTE_SFTP_IP' is not set or is empty."
  exit 1
fi

until nc $REMOTE_SFTP_IP 22 &>/dev/null; do
  echo "Waiting for $REMOTE_SFTP_IP to be reachable..."
  sleep 5
done

rsync -urltv --delete -e "ssh -o StrictHostKeyChecking=no -i keys/id_ed25519 -q" ./artifacts/ sftpuser@$REMOTE_SFTP_IP:/var/sftp/data/
