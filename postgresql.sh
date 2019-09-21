#!/bin/bash

ID=`id -u`

if [ "x$ID" != "x0" ]; then
  echo "Run as root!"
  exit 1
fi

apt list | grep check-postgres/
if [ $? -ne 0 ]; then
     echo "########################################################"
     echo "###   Installing PostgreSQL from Ubuntu repository   ###"
     echo "########################################################"
     apt install postgresql -y
     if [ $? -ne 0 ]; then
          echo
          echo Installation Failed!
          exit 0
     fi
     echo
     echo
fi

echo "############################################"
echo "###   Creating the onlyoffice database   ###"
echo "############################################"
sudo -u postgres psql -c "CREATE DATABASE onlyoffice;"
if [ $? -ne 0 ]; then
     echo
     echo Creation Failed!
     exit 0
fi
echo
echo

echo "########################################"
echo "###   Creating the onlyoffice user   ###"
echo "########################################"
sudo -u postgres psql -c "CREATE USER onlyoffice WITH password 'onlyoffice';"
if [ $? -ne 0 ]; then
     echo
     echo Creation Failed!
     exit 0
fi
echo
echo

echo "###############################"
echo "###   Granting permission   ###"
echo "###############################"
sudo -u postgres psql -c "GRANT ALL privileges ON DATABASE onlyoffice TO onlyoffice;"
if [ $? -ne 0 ]; then
     echo
     echo Grant Failed!
     exit 0
fi
echo
echo
