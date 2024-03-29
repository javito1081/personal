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
	echo "###################################"
	echo "###   Securing MariaDB Server   ###"
	echo "###################################"
	wget https://raw.githubusercontent.com/javito1081/personal/master/mysql_secure.sh > /dev/null 2>&1
	chmod a+x mysql_secure.sh
	./mysql_secure.sh rootnodoubt > /dev/null 2>&1
	rm mysql_secure.sh
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

systemctl status mariadb | grep "Active: active" > /dev/null 2>&1
if [ $? == 0 ]; then
	cat /etc/mysql/my.cnf | grep -F [mysqld] > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		bash -c "echo -en '\n[mysqld]' >> /etc/mysql/my.cnf"
	fi

	cat /etc/mysql/my.cnf | grep innodb_large_prefix=true > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		sed -i "/^\[mysqld\]/a innodb_large_prefix=true" /etc/mysql/my.cnf
	fi

	cat /etc/mysql/my.cnf | grep innodb_file_format=barracuda > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		sed -i "/^\[mysqld\]/a innodb_file_format=barracuda" /etc/mysql/my.cnf
	fi

	cat /etc/mysql/my.cnf | grep innodb_file_per_table=1 > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		sed -i "/^\[mysqld\]/a innodb_file_per_table=1" /etc/mysql/my.cnf
	fi
else
	echo
	echo MariaDB is not Active, check \"journalctl -xe\" for details
	exit 1
fi

service mysql restart
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


apt show php7.2-mbstring > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php7.2-mbstring
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

apt show php-apcu > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing php-apcu
    apt install -y php-apcu > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	service php7.2-fpm restart
	echo
	echo Done!
fi
rm result

cat /etc/php/7.2/fpm/pool.d/www.conf | grep ";clear_env = no" > /dev/null 2>&1
if [ $? == 0 ]; then
	sed -i "s/\;clear_env = no/clear_env = no/g" /etc/php/7.2/fpm/pool.d/www.conf
	systemctl restart php7.2-fpm
fi
echo
echo


echo "################################################"
echo "###   Checking/installing Nginx Web Server   ###"
echo "################################################"
systemctl disable apache2 > /dev/null 2>&1
systemctl stop apache2 > /dev/null 2>&1
apt show nginx > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo
	echo Installing nginx
    apt install -y nginx > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo Installation Failed!
		exit 1
	fi
	rm /etc/nginx/sites-enabled/default
	echo
	echo Done!
	systemctl status nginx | grep Active
fi
rm result
echo
echo


echo Checking status on php7.2-fpm
systemctl status php7.2-fpm | grep Active
echo
echo

echo "##################################"
echo "###   Done with Dependencies   ###"
echo "##################################"
echo
# read -n 1 -s -r -p "Press any key to continue"
echo
echo
