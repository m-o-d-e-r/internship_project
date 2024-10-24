#!/bin/bash

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

echo -n "[Enter NFS IP] > "
read NFS_SERVER

echo -n "[Enter NFS path] > "
read NFS_PATH

helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=$NFS_SERVER \
    --set nfs.path=$NFS_PATH
