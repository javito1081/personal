#!/bin/bash

ID=`id -u`

if [ "x$ID" != "x0" ]; then
	echo "Run as root!"
    exit 1
fi

clear

echo "#################################"
echo "###   installation Starting   ###"
echo "#################################"
echo
echo

echo "############################################"
echo "###   Updating and Upgrading Databases   ###"
echo "############################################"
apt update
apt upgrade -y
echo
echo 

echo "################################################"
echo "###   Checking/installing Nginx Web Server   ###"
echo "################################################"
apt show nginx > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing nginx
    apt install -y nginx > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
    systemctl enable nginx > /dev/null 2>&1
    systemctl start nginx > /dev/null 2>&1
fi
rm result

systemctl status nginx | grep Active
echo
echo


echo "#####################################################"
echo "###   Checking/installing MariaDB Server/Client   ###"
echo "#####################################################"
apt show mariadb-server > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing mariadb-server
    apt install -y mariadb-server > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show mariadb-client > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing mariadb-client
    apt install -y mariadb-client > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

systemctl status mariadb | grep Active
echo
echo


echo "#######################################################"
echo "###   Checking/installing PHP7.2 and Dependencies   ###"
echo "#######################################################"
apt show php7.2 > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2
    apt install -y php7.2 > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-fpm > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-fqm
    apt install -y php7.2-fpm > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-mysql > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-mysql
    apt install -y php7.2-mysql > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php-common > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php-common
    apt install -y php-common > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-cli > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-cli
    apt install -y php7.2-cli > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-common > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-common
    apt install -y php7.2-common > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-json > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-json
    apt install -y php7.2-json > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-opcache > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing pgp7.2-opcache
    apt install -y php7.2-opcache > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-readline > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-readline
    apt install -y php7.2-readline > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-mbstring > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing nginx php7.2-mbstring
    apt install -y php7.2-mbstring > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-xml > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-xml
    apt install -y php7.2-xml > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-gd > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-gd
    apt install -y php7.2-gd > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-curl > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-curl
    apt install -y php7.2-curl > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php-imagick > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php-imagick
    apt install -y php-imagick > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-zip > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-zip
    apt install -y php7.2-zip > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-bz2 > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-bz2
    apt install -y php7.2-bz2 > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-intl > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-intl
    apt install -y php7.2-intl > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	echo
	echo Done!
fi
rm result

apt show php7.2-fpm > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? == 0 ]; then
    systemctl start php7.2-fpm > /dev/null 2>&1
	systemctl enable php7.2-fpm > /dev/null 2>&1
fi
rm result

echo Checking status on php7.2-fpm
systemctl status php7.2-fpm | grep Active
echo
echo

echo "##################################"
echo "###   Done with Dependencies   ###"
echo "##################################"
sleep 5
echo
echo

exit 0
