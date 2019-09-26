#!/bin/bash
# include this boilerplate

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

ID=`id -u`

if [ "x$ID" != "x0" ]; then
  echo "Run as root!"
  exit 1
fi

if ! [ -z $1 ]; then
	option=1
	jumpto beg
fi

clear
echo "############################################################################################"
echo "#                                                                                          #"
echo "#   1 - Install Certbot + SSL + Cron Job for Auto-Renew ( New Installation )               #"
echo "#   2 - Install Certbot + SSL ( New Installation ) **This will not renew automatically**   #"
echo "#   3 - Install SSL and create Cron Job for Auto-Renew                                     #"
echo "#   4 - Renew SSL Certificate + Cron Job for Auto-Renew                                    #"
echo "#   5 - Exit                                                                               #"
echo "#                                                                                          #"
echo "############################################################################################"
jumpto startoption
startoption:
read -p "Select your option ( 1-5 ): " option
echo
echo

if [[ $option == 5 ]]; then                                      # Exit
    exit 0
fi

jumpto beg
beg:
clear
echo "############################################################"
echo "###   Stopping Zimbra Proxy (if installed) and Mailbox   ###"
echo "############################################################"
sudo -u zimbra /opt/zimbra/bin/zmcontrol status | grep proxy &> /dev/null
if [ $? == 0 ]; then
	sudo -u zimbra /opt/zimbra/bin/zmproxyctl stop
fi
sudo -u zimbra /opt/zimbra/bin/zmmailboxdctl stop
echo
echo
   

if [[ $option == 1 || $option == 2 ]]; then
	rm result
	apt show certbot > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
	echo "##############################"
	echo "###   Installing Certbot   ###"
	echo "##############################"
	apt update  > /dev/null 2>&1
	rm result
	apt show software-properties-common > /dev/null 2>&1 > result ;cat result | grep "APT-Manual-Installed" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		apt install -y software-properties-common > /dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo
			echo Installation Failed!
			exit 1
		fi
	fi
	add-apt-repository -y ppa:certbot/certbot > /dev/null 2>&1
	apt update  > /dev/null 2>&1
	apt install -y certbot
	if [ $? -ne 0 ]; then
	    echo
	    echo Installation Failed!
        exit 1
	fi
    fi
    echo
    echo
fi

if [ $option -ne 4 ]; then
    echo "##################################"
    echo "###   Obtaining Certificates   ###"
    echo "##################################"
    certbot certonly --standalone
    if [ $? -ne 0 ]; then
        exit 1
    fi
    ls /etc/letsencrypt/live/ | grep '^[a-z]*\.[a-z]*\.[a-z]' -m 1 > /opt/zimbra/ssl/domain
	domain=$(cat /opt/zimbra/ssl/domain | grep '^[a-z]*\.[a-z]*\.[a-z]' -m 1)
    #domain=$(sudo cat /var/log/letsencrypt/letsencrypt.log | grep -o -P '(?<=live/).*(?=/)' | head -1)
    echo
    echo

    echo "####################################"
    echo "###   Getting Root Certificate   ###"
    echo "####################################"
    wget -O /etc/letsencrypt/live/$domain/RootX3.pem https://raw.githubusercontent.com/javito1081/personal/master/RootX3.pem
    if [ $? -ne 0 ]; then
	echo
	echo Download Failed!
        exit 0
    fi
    echo
    echo
fi

echo "#################################################"
echo "###   Copying Certificates to Zimbra Folder   ###"
echo "#################################################"
domain=$(cat /opt/zimbra/ssl/domain | grep '^[a-z]*\.[a-z]*\.[a-z]' -m 1)

if [ $option -ne 4 ]; then
	mkdir /opt/zimbra/ssl/letsencrypt
fi
cp /etc/letsencrypt/live/$domain/cert.pem /opt/zimbra/ssl/letsencrypt/cert.pem
cp /etc/letsencrypt/live/$domain/fullchain.pem /opt/zimbra/ssl/letsencrypt/fullchain.pem
cp /etc/letsencrypt/live/$domain/privkey.pem /opt/zimbra/ssl/letsencrypt/privkey.pem
cat /etc/letsencrypt/live/$domain/chain.pem /etc/letsencrypt/live/$domain/RootX3.pem > /opt/zimbra/ssl/letsencrypt/chain.pem

if [ $option -ne 4 ]; then
	chown zimbra:zimbra -R /opt/zimbra/ssl/letsencrypt/
	if [ $? -ne 0 ]; then
		echo 
		echo Failed to set Zimbra Owner
		exit 0
	fi
fi
echo
echo

echo "###################################"
echo "###   Verifiying Certificates   ###"
echo "###################################"
cd /opt/zimbra/ssl/letsencrypt/
sudo -u zimbra /opt/zimbra/bin/zmcertmgr verifycrt comm privkey.pem cert.pem chain.pem
if [ $? -ne 0 ]; then
    echo
    echo Verification Failed!
    exit 0
fi
echo
echo
 
echo "#######################################"
echo "###   Backing up Old Certificates   ###"
echo "#######################################"
cp -a /opt/zimbra/ssl/zimbra /opt/zimbra/ssl/zimbra.$(date "+%Y-%m-%d")
echo
echo

if [ $option -ne 4 ]; then    
    echo "##########################################"
    echo "###   Copying Commercial Certificate   ###"
    echo "##########################################"
    cp /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
    chown zimbra:zimbra /opt/zimbra/ssl/zimbra/commercial/commercial.key
    if [ $? -ne 0 ]; then
	echo
	echo Failed to copy CommCert
        exit 0
    fi
    echo
    echo
fi

echo "##################################"
echo "###   Deploying Certificates   ###"
echo "##################################"
sudo -u zimbra /opt/zimbra/bin/zmcertmgr deploycrt comm cert.pem chain.pem
if [ $? -ne 0 ]; then
	echo
	echo Deployment Failed!
    exit 0
fi
echo
echo

echo "############################################################"
echo "###   Starting Zimbra Proxy (if installed) and Mailbox   ###"
echo "############################################################"
sudo -u zimbra /opt/zimbra/bin/zmcontrol status | grep proxy &> /dev/null
if [ $? == 0 ]; then
    sudo -u zimbra /opt/zimbra/bin/zmproxyctl start
fi
sudo -u zimbra /opt/zimbra/bin/zmmailboxdctl start
echo
echo
    
if [ $option -ne 2 ]; then
	echo "##############################################"
	echo "###   Installing Cron Job for Auto-Renew   ###"
	echo "##############################################"
	wget -O /opt/zimbra/ssl/letsencrypt/autorenew.sh https://raw.githubusercontent.com/javito1081/personal/master/autorenew.sh
	sudo sh -c "echo \"*/2 * * * * /opt/zimbra/ssl/letsencrypt/autorenew.sh > /opt/zimbra/ssl/letsencrypt/autorenew.log\" >> /var/spool/cron/crontabs/root"
	echo
	echo
fi
echo "##################################"
echo "###   Installation Complete    ###"
echo "##################################"
echo
echo
exit 0
