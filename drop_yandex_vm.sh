#!/bin/bash
NAME="ydv-vm"
yc compute instance list | grep $NAME
read -p "Delete all computers? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
for I in `yc compute instance list | grep "$NAME" | cut -f 3 -d '|'` 
do
	yc compute instance delete $I
done
yc compute instance list | grep $NAME
