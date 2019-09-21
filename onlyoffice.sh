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

echo "#########################################"
echo "###   Adding OnlyOffice repository.   ###"
echo "#########################################"
echo "deb http://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list
if [ $? -ne 0 ]; then
     echo
     echo Adding Failed!
     exit 0
fi
echo
echo

echo "############################################"
echo "###   Importing OnlyOffice public key.   ###"
echo "############################################"
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
if [ $? -ne 0 ]; then
     echo
     echo Importing Failed!
     exit 0
fi
echo
echo

echo "######################################################"
echo "###                                                ###"
echo "###   Refreshing local package indexes.            ###"
echo "###                                                ###"
echo "###   Note: onlyoffice will install nginx server   ###"
echo "###         so u might need to stop Apache if      ###"
echo "###         its running.                           ###"
echo "###                                                ###"
echo "######################################################"
apt update
echo
echo

echo "#######################################################"
echo "###                                                 ###"
echo "###   Also before we start, if u have any other     ###"
echo "###   service running or if u just want to change   ###"
echo "###   the port, now its the time :-)                ###"
echo "###                                                 ###"
echo "#######################################################"
jumpto changesel
changesel:
read -p "Would u like to change the default nginx server port 80? (Y/n): " choice

case $choice in
   y|Y ) choice=Y;;
   n|N ) choice=n;;
   * ) jumpto changesel;;
esac

if [[ $choice == Y ]]; then
   portsel:
   read -p "Type the port number: " port

   if ! [[ "$port" =~ ^[0-9]+$ ]]; then
      jumpto portsel
   else
      if (( $port >= 1 && $port <= 65535 )); then
         jumpto setport
      else
         jumpto portsel
      fi
   fi

   setport:
   echo onlyoffice-documentserver onlyoffice/ds-port select $port | sudo debconf-set-selections
   if [ $? -ne 0 ]; then
      echo
      echo Setting port Failed!
      exit 0
   fi
   jumpto onlyoffice
fi
echo
echo


onlyoffice:
echo "################################################"
echo "###                                          ###"
echo "###   Installing Onlyoffice-DocumentServer   ###"
echo "###   Note: database pass is \"onlyoffice\"    ###"
echo "###         without the quotes.              ###"
echo "###                                          ###"
echo "################################################"
apt install onlyoffice-documentserver -y
if [ $? -ne 0 ]; then
   echo
   echo Installation Failed!
   exit 0
fi
echo
echo

echo "#######################################################################################"
echo "###                                                                                 ###"
echo "###   If there's another server listening on port 8080, which is the default port   ###"
echo "###   for SpellChecker, now is the time to change it.                               ###"
echo "###                                                                                 ###"
echo "###   note: Please say no if this is a reinstalation and proceed to manually        ###" 
echo "###         edit the local.json file.                                               ###"
echo "###                                                                                 ###"
echo "#######################################################################################"
jumpto changespell
changespell:
read -p "Would you like to change the default SpellChecker port 8080? (Y/n): " spell

case $spell in
   y|Y ) spell=Y;;
   n|N ) spell=n;;
   * ) jumpto changespell;;
esac

if [[ $spell == Y ]]; then
   spellport:
   read -p "Type the port number: " spellport

   if ! [[ "$spellport" =~ ^[0-9]+$ ]]; then
      jumpto spellport
   else
      if (( $spellport >= 1 && $spellport <= 65535 )); then
         jumpto setselport
      else
         jumpto spellport
      fi
   fi

   setselport:
   sed -i "/^{/a \   \"SpellChecker\": {\n           \"server\": {\n              \"port\": $spellport\n           }\n     }," /etc/onlyoffice/documentserver/local.json
   service nginx restart
   supervisorctl restart all
   
   jumpto end
else
   spellport=8080
   jumpto end
fi

end:
echo "###############################################"
echo "###                                         ###"
echo "###         Installation Complete!          ###"
echo "###                                         ###"
echo "###   Test at http://localhost:$spellport   ###"
echo "###                                         ###"
echo "###############################################"
echo
echo
