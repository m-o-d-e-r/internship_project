#!/bin/bash

# Example
# ./update_hosts.sh hostname=schedule-db hostname2=schedule-mongo

echo "$0 started..."

DELIMETER="="

for address_meta in "$@"
do
    echo "Processing '$address_meta'..."

    current_host=$(echo $address_meta | awk -F $DELIMETER '{print $1}')
    target_host=$(echo $address_meta | awk -F $DELIMETER '{print $2}')

    echo -e "Current host: $current_host\nTarget host: $target_host"

    db_ip=$(dig +short "$(echo $current_host | awk -F ":" '{print $1}')")

    echo "Resolved IP: $db_ip"

    if grep -q "$target_host" /etc/hosts; then
        echo "'$target_host' already exists in /etc/hosts. Skipping..."
    elif [[ -n $db_ip ]]; then
        echo "Appending '$db_ip' to /etc/hosts"
        echo "$db_ip $target_host" >> /etc/hosts
        cat /etc/hosts
    else
        echo "Failed to resolve '$current_host' to an IP address"
    fi
done
