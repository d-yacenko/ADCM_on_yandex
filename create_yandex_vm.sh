#!/bin/bash
NAME="test-adcm-edu-ydv-vm"
NUM=6
for I in {1..$NUM} 
do

yc compute instance create \
    --name $NAME$I \
    --zone ru-central1-c \
    --network-interface subnet-name=develop \
    --preemptible \
    --create-boot-disk image-folder-id=standard-images,image-family=centos-7 \
    --ssh-key ~/.ssh/id_rsa.pub
done
yc compute instance list | grep $NAME  | awk '{print $4, $11}' | sort
