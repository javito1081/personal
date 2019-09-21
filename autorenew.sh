#!/bin/bash

# Stopping Services
sudo -u zimbra /opt/zimbra/bin/zmcontrol status | grep proxy &> /dev/null
if [ $? == 0 ]; then
    sudo -u zimbra /opt/zimbra/bin/zmproxyctl stop
fi
sudo -u zimbra /opt/zimbra/bin/zmmailboxdctl stop

# Copiying Certs
domain=$(cat /opt/zimbra/ssl/domain)
mkdir /opt/zimbra/ssl/letsencrypt
cp /etc/letsencrypt/live/$domain/cert.pem /opt/zimbra/ssl/letsencrypt/cert.pem
cp /etc/letsencrypt/live/$domain/fullchain.pem /opt/zimbra/ssl/letsencrypt/fullchain.pem
cp /etc/letsencrypt/live/$domain/privkey.pem /opt/zimbra/ssl/letsencrypt/privkey.pem
cat /etc/letsencrypt/live/$domain/chain.pem /etc/letsencrypt/live/$domain/RootX3.pem > /opt/zimbra/ssl/letsencrypt/chain.pem
chown zimbra:zimbra -R /opt/zimbra/ssl/letsencrypt/

# Backing up old Certs
cp -a /opt/zimbra/ssl/zimbra /opt/zimbra/ssl/zimbra.$(date "+%Y%m%d")

# Deploying
cd /opt/zimbra/ssl/letsencrypt/
sudo -u zimbra /opt/zimbra/bin/zmcertmgr deploycrt comm cert.pem chain.pem

# Starting Services
sudo -u zimbra /opt/zimbra/bin/zmcontrol status | grep proxy &> /dev/null
if [ $? == 0 ]; then
    sudo -u zimbra /opt/zimbra/bin/zmproxyctl start
fi
sudo -u zimbra /opt/zimbra/bin/zmmailboxdctl start
