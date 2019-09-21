#!/bin/bash

ID=`id -u`

if [ "x$ID" != "x0" ]; then
  echo "Run as root!"
  exit 1
fi

echo "#############################################"
echo "###   Install Redis Server and Rabbitmq   ###"
echo "#############################################"
echo Checking Redis
sudo apt list | grep redis-server/bionic
if [ $? -ne 0 ]; then
     apt install redis-server -y
fi
echo Checking Rabbit
sudo apt list | grep rabbitmq-server/bionic
if [ $? -ne 0 ]; then
     apt install rabbitmq-server -y
fi
echo
echo

echo "###############################"
echo "###   Check their status.   ###"
echo "###############################"
systemctl status redis-server | grep Active
systemctl status rabbitmq-server | grep Active
echo
echo
