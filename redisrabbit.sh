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
apt show redis-server | grep APT-Manual-Installed
if [ $? -ne 0 ]; then
     apt install redis-server -y
     if [ $? -ne 0 ]; then
          echo
          echo Installation Failed!
          exit 1
     fi
fi
echo Checking Rabbit
apt show rabbitmq-server | grep APT-Manual-Installed
if [ $? -ne 0 ]; then
     apt install rabbitmq-server -y
     if [ $? -ne 0 ]; then
          echo
          echo Installation Failed!
          exit 1
     fi
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
