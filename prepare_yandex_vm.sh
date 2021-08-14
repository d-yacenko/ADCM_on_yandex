#!/bin/bash
NAME="ydv-vm"
HOSTS=`yc compute instance list | grep $NAME | awk '{ print $11}'`
for H in $HOSTS
do
	sed -i /$H/d ~/.ssh/known_hosts
	scp -o StrictHostKeyChecking=no -r ~/.ssh yc-user@$H:/tmp/.ssh 	 >/dev/null
	ssh -o StrictHostKeyChecking=no yc-user@$H 'cat /tmp/.ssh/id_rsa.pub >> /tmp/.ssh/authorized_keys'
	ssh -o StrictHostKeyChecking=no yc-user@$H sudo cp -rf /tmp/.ssh /root/
	ssh -o StrictHostKeyChecking=no yc-user@$H rm -rf /tmp/.ssh 
	sed -i /$H/d ~/.ssh/known_hosts
done

HOST_ADCM=`yc compute instance list | grep ydv-vm1 | awk '{ print $11}'`
ssh -o StrictHostKeyChecking=no yc-user@$HOST_ADCM sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
ssh -o StrictHostKeyChecking=no yc-user@$HOST_ADCM sudo yum install -y yum-utils docker device-mapper-persistent-data lvm2
ssh -o StrictHostKeyChecking=no yc-user@$HOST_ADCM sudo systemctl start docker
ssh -o StrictHostKeyChecking=no yc-user@$HOST_ADCM sudo systemctl enable docker

ssh -o StrictHostKeyChecking=no yc-user@$HOST_ADCM sudo docker pull -q arenadata/adcm:latest
ssh -o StrictHostKeyChecking=no yc-user@$HOST_ADCM sudo setenforce 0
ssh -o StrictHostKeyChecking=no yc-user@$HOST_ADCM sudo docker create --name adcm -p 8000:8000 -v /opt/adcm:/adcm/data arenadata/adcm:latest
ssh -o StrictHostKeyChecking=no yc-user@$HOST_ADCM sudo docker start adcm

echo "===Created machines=="
yc compute instance list | grep $NAME |  awk '{print $4, $11}' | sort
echo "\n===PK for host add to adcm==="
cat ~/.ssh/id_rsa
firefox "$HOST_ADCM:8000"
