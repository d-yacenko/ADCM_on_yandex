#!/bin/bash
NAME=ydv-vm
#NUM=6
for I in {1..6} 
do
echo $NAME$I
yc compute instance create \
    --name $NAME$I \
    --cores=4 \
      --memory=8 \
    --zone ru-central1-b \
    --network-interface subnet-name=default-ru-central1-b \
    --preemptible \
    --create-boot-disk image-folder-id=standard-images,size=45,image-family=centos-7 \
    --ssh-key ~/.ssh/id_rsa.pub
done
yc compute instance list | grep $NAME  | awk '{print $4, $11}' | sort
