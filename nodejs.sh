#!/bin/bash

ID=`id -u`

if [ "x$ID" != "x0" ]; then
  echo "Run as root!"
  exit 1
fi

echo "######################################"
echo "###   Adding Node.js repostiory.   ###"
echo "######################################"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
if [ $? -ne 0 ]; then
     echo
     echo Adding Failed!
     exit 1
fi
echo
echo

apt show nodejs | grep APT-Manual-Installed
if [ $? -ne 0 ]; then
     echo "############################"
     echo "###   Install Node.js.   ###"
     echo "############################"
     apt install nodejs -y
     if [ $? -ne 0 ]; then
          echo
          echo Installation Failed!
          exit 1
     fi
     echo
     echo
fi
