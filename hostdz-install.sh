##################### FIRST LINE
# ---------------------------
#!/bin/bash
# ---------------------------
#
# |--------------------------------------------------------------|
# | The script thank you for Notos (notos.korsan@gmail.com)      |
# |--------------------------------------------------------------|
# | The script was further developed Tiby08 (tiby0108@gmail.com) |
# |--------------------------------------------------------------|
# | Version info: v0.2 beta                                      |
# |--------------------------------------------------------------|
#
#
  SBFSCURRENTVERSION1=0.2  
  OS1=$(lsb_release -si)
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
txtrst='\e[0m'    # Text Reset
function getString
{
  local ISPASSWORD=$1
  local LABEL=$2
  local RETURN=$3
  local DEFAULT=$4
  local NEWVAR1=a
  local NEWVAR2=b
  local YESYES=YESyes
  local NONO=NOno
  local YESNO=$YESYES$NONO

  while [ ! $NEWVAR1 = $NEWVAR2 ] || [ -z "$NEWVAR1" ];
  do

    if [ "$ISPASSWORD" == "YES" ]; then
      echo -e -n "${bldgrn}$LABEL${bldpur}"
      read -s -p "$DEFAULT" -p " " NEWVAR1
      echo -e "${txtrst}"
    else
      echo -e -n "${bldgrn}$LABEL${bldpur}"
      read -e -i "$DEFAULT" -p " " NEWVAR1
      echo -e -n "${txtrst}"
    fi
    if [ -z "$NEWVAR1" ]; then
      NEWVAR1=a
      continue
    fi

    if [ ! -z "$DEFAULT" ]; then
      if grep -q "$DEFAULT" <<< "$YESNO"; then
        if grep -q "$NEWVAR1" <<< "$YESNO"; then
          if grep -q "$NEWVAR1" <<< "$YESYES"; then
            NEWVAR1=YES
          else
            NEWVAR1=NO
          fi
        else
          NEWVAR1=a
        fi
      fi
    fi

    if [ "$NEWVAR1" == "$DEFAULT" ]; then
      NEWVAR2=$NEWVAR1
    else
      if [ "$ISPASSWORD" == "YES" ]; then
         echo -e -n "${bldgrn}Please again: ${bldpur}"
        read NEWVAR2
         echo -e "${txtrst}"
      else
         echo -e -n "${bldgrn}Please again: ${bldpur}"
        read NEWVAR2
         echo -e -n "${txtrst}"
      fi
      if [ -z "$NEWVAR2" ]; then
        NEWVAR2=b
        continue
      fi
    fi


    if [ ! -z "$DEFAULT" ]; then
      if grep -q "$DEFAULT" <<< "$YESNO"; then
        if grep -q "$NEWVAR2" <<< "$YESNO"; then
          if grep -q "$NEWVAR2" <<< "$YESYES"; then
            NEWVAR2=YES
          else
            NEWVAR2=NO
          fi
        else
          NEWVAR2=a
        fi
      fi
    fi
   ## echo "---> $NEWVAR2"

  done
  eval $RETURN=\$NEWVAR1
}
# 0.
echo -e -n "${txtrst}"
if [[ $EUID -ne 0 ]]; then
  clear
  echo
  echo -e "${bldred}This script must be run as root${txtrst}" 1>&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

clear

# 1.

#localhost is ok this rtorrent/rutorrent installation
IPADDRESS1=`ifconfig | sed -n 's/.*inet addr:\([0-9.]\+\)\s.*/\1/p' | grep -v 127 | head -n 1`
CHROOTJAIL1=NO

#those passwords will be changed in the next steps
PASSWORD1=a
PASSWORD2=b


clear

getString NO  "SeedBox username:" NEWUSER1 $1
getString NO "SeedBox user($NEWUSER1) password:" PASSWORD1 $2
getString NO  "IP or host:" IPADDRESS1 $IPADDRESS1
getString NO  "The config shared?(YES/NO)" SHARED1 $3
if [ "$SHARED1" = "YES" ]; then
	SHAREDSEEDBOX1=NO
else
	SHAREDSEEDBOX1=YES
fi
getString NO  "The server SSD?(YES/NO)" SSD1 $4
#getString NO  "SSH port: " NEWSSHPORT1 22
#getString NO  "vsftp port (alap 21): " NEWFTPPORT1 21
#getString NO  "Do you want to have some of your users in a chroot jail? " CHROOTJAIL1 YES
##getString NO  "You need install Webmin?" INSTALLWEBMIN1 YES
##getString NO  "You need install Fail2ban?" INSTALLFAIL2BAN1 YES
##getString NO  "You need install VNC?" INSTALLVNC1 $SHAREDSEEDBOX1
##getString NO  "You need install Bitorrentsync?" INSTALLBITORRENTSYNC1 $SHAREDSEEDBOX1
##getString NO  "You need install NZBGet?" INSTALLNZBGET1 $SHAREDSEEDBOX1
##getString NO  "You need install Subsonic?" INSTALLSUBSONIC1 $SHAREDSEEDBOX1
##getString NO  "OpenVPN install?" INSTALLOPENVPN1 NO
##if [ "$INSTALLOPENVPN1" = "YES" ]; then
##getString NO  "OpenVPN port:" OPENVPNPORT1 31195
##fi
##getString NO  "You need install SABnzbd?" INSTALLSABNZBD1 $SHAREDSEEDBOX1
##getString NO  "You need install Rapidleech?" INSTALLRAPIDLEECH1 $SHAREDSEEDBOX1
##getString NO  "You need install Deluge?" INSTALLDELUGE1 $SHAREDSEEDBOX1
##getString NO  "You need install uTorrent?" INSTALLUTORRENT1 $SHAREDSEEDBOX1
##getString NO  "You need install Transmission?" INSTALLTRANSMISSION1 $SHAREDSEEDBOX1
###getString NO  "Wich RTorrent version would you like to install, '0.9.2' or '0.9.3' or '0.9.4'? " RTORRENT1 0.9.4


NEWFTPPORT1=21
NEWSSHPORT1=22
INSTALLWEBMIN1=YES
INSTALLFAIL2BAN1=NO
INSTALLNZBGET1=$SHAREDSEEDBOX1
INSTALLSABNZBD1=YES
##INSTALLRAPIDLEECH1=NO
###INSTALLDELUGE1=NO
INSTALLOPENVPN1=YES
OPENVPNPORT1 31195
#getString NO  "Wich rTorrent would you like to use, '0.8.9' (older stable) or '0.9.2' (newer but banned in some trackers)? " RTORRENT1 0.9.2
RTORRENT1=0.9.4

if [ "$RTORRENT1" != "0.9.3" ] && [ "$RTORRENT1" != "0.9.2" ] && [ "$RTORRENT1" != "0.9.4" ]; then
  echo "$RTORRENT1 typed is not 0.9.4 or 0.9.3 or 0.9.2!"
  exit 1
fi

if [ "$RTORRENT1" = "0.9.4" ]; then
  LIBTORRENT1=0.13.4
fi

if [ "$RTORRENT1" = "0.9.2" ]; then
  LIBTORRENT1=0.13.2
else
  LIBTORRENT1=0.12.9
fi

apt-get --yes install whois sudo makepasswd git

rm -f -r /etc/hostdz
git clone -b v$SBFSCURRENTVERSION1 https://github.com/fjdhgjaf/hostdz.git /etc/hostdz
mkdir -p cd /etc/hostdz/source
mkdir -p cd /etc/hostdz/users

if [ ! -f /etc/hostdz/hostdz-install.sh ]; then
  clear
  echo Looks like somethig is wrong, this script was not able to download its whole git repository.
  set -e
  exit 1
fi

chmod -R 755 /etc/hostdz/
# 3.1

cp /etc/apt/sources.list /root/old_sources.list
rm -f /etc/apt/sources.list
cp /etc/hostdz/ubuntu.1204-precise.etc.apt.sources.list.template /etc/apt/sources.list

#show all commands
set -x verbose

# 4.
#perl -pi -e "s/Port 22/Port $NEWSSHPORT1/g" /etc/ssh/sshd_config
#perl -pi -e "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
perl -pi -e "s/#Protocol 2/Protocol 2/g" /etc/ssh/sshd_config
perl -pi -e "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config

groupadd sshdusers
echo "" | tee -a /etc/ssh/sshd_config > /dev/null
echo "UseDNS no" | tee -a /etc/ssh/sshd_config > /dev/null
echo "AllowGroups sshdusers" >> /etc/ssh/sshd_config
sudo cp /lib/terminfo/l/linux /usr/share/terminfo/l/
awk -F: '$3 == 1000 {print $1}' /etc/passwd | xargs usermod --groups sshdusers

service ssh restart

# 6.
#remove cdrom from apt so it doesn't stop asking for it
perl -pi -e "s/deb cdrom/#deb cdrom/g" /etc/apt/sources.list

#add non-free sources to Debian Squeeze# those two spaces below are on purpose
perl -pi -e "s/squeeze main/squeeze  main contrib non-free/g" /etc/apt/sources.list
perl -pi -e "s/squeeze-updates main/squeeze-updates  main contrib non-free/g" /etc/apt/sources.list

# 7.
# update and upgrade packages

apt-get --yes update
apt-get --yes upgrade

# 8.
#install all needed packages

##apt-get --yes build-dep znc
apt-get --yes install apache2 apache2-utils autoconf build-essential ca-certificates comerr-dev curl cfv quota mktorrent dtach htop irssi libapache2-mod-php5 libcloog-ppl-dev libcppunit-dev libcurl3 libcurl4-openssl-dev libncurses5-dev libterm-readline-gnu-perl libsigc++-2.0-dev libperl-dev openvpn libssl-dev libtool libxml2-dev ncurses-base ncurses-term ntp openssl patch libc-ares-dev pkg-config php5 php5-cli php5-dev php5-curl php5-geoip php5-mcrypt php5-gd php5-xmlrpc pkg-config python-scgi screen ssl-cert subversion texinfo unzip zlib1g-dev expect joe automake1.9 flex bison debhelper binutils-gold libav-tools libarchive-zip-perl libnet-ssleay-perl libhtml-parser-perl libxml-libxml-perl libjson-perl libjson-xs-perl libxml-libxslt-perl libxml-libxml-perl libjson-rpc-perl libarchive-zip-perl znc tcpdump
if [ $? -gt 0 ]; then
  set +x verbose
  echo -e "${bldred}#${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}# | The script thank you for Notos (notos.korsan@gmail.com)      |${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}# | The script was further developed Tiby08 (tiby0108@gmail.com) |${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}#"
  echo
  echo
  echo *** ERROR ***
  echo
  echo "Looks like somethig is wrong with apt-get install, aborting."
  echo
  echo
  echo
  set -e
  exit 1
fi
apt-get --yes install zip
apt-get --yes install python-software-properties

apt-get --yes install rar
if [ $? -gt 0 ]; then
  apt-get --yes install rar-free
fi

apt-get --yes install unrar
if [ $? -gt 0 ]; then
  apt-get --yes install unrar-free
fi

apt-get --yes install dnsutils

if [ "$CHROOTJAIL1" = "YES" ]; then
  cd /etc/hostdz
  tar xvfz jailkit-2.15.tar.gz -C /etc/hostdz/source/
  cd source/jailkit-2.15
  ./debian/rules binary
  cd ..
  dpkg -i jailkit_2.15-1_*.deb
fi

# 8.1 additional packages for Ubuntu
# this is better to be apart from the others
apt-get --yes install php5-fpm
apt-get --yes install php5-xcache
apt-get --yes install landscape-common

#Check if its Debian an do a sysvinit by upstart replacement:

if [ "$OS1" = "Debian" ]; then
  echo 'Yes, do as I say!' | apt-get -y --force-yes install upstart
fi

# 8.3 Generate our lists of ports and RPC and create variables

#permanently adding scripts to PATH to all users and root
echo "PATH=$PATH:/etc/hostdz:/sbin" | tee -a /etc/profile > /dev/null
echo "export PATH" | tee -a /etc/profile > /dev/null
echo "PATH=$PATH:/etc/hostdz:/sbin" | tee -a /root/.bashrc > /dev/null
echo "export PATH" | tee -a /root/.bashrc > /dev/null

rm -f /etc/hostdz/ports.txt
for i in $(seq 51101 51999)
do
  echo "$i" | tee -a /etc/hostdz/ports.txt > /dev/null
done

#rm -f /etc/hostdz/rpc.txt
#for i in $(seq 2 1000)
#do
#  echo "RPC$i"  | tee -a /etc/hostdz/rpc.txt > /dev/null
#done

# 8.4

if [ "$INSTALLWEBMIN1" = "YES" ]; then
  #if webmin isup, download key
  WEBMINDOWN=YES
  ping -c1 -w2 www.webmin.com > /dev/null
  if [ $? = 0 ] ; then
    ##wget -t 5 http://www.webmin.com/jcameron-key.asc
    cp /etc/hostdz/jcameron-key.asc /root/jcameron-key.asc
	apt-key add jcameron-key.asc
    if [ $? = 0 ] ; then
      WEBMINDOWN=NO
    fi
  fi

  if [ "$WEBMINDOWN" = "NO" ]; then
    apt-get --yes update
    apt-get --yes install webmin
  fi
fi

if [ "$INSTALLFAIL2BAN1" = "YES" ]; then
  apt-get --yes install fail2ban
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.original
  cp /etc/hostdz/etc.fail2ban.jail.conf.template /etc/fail2ban/jail.conf
  fail2ban-client reload
fi

# 9.

#a2enmod scgi ############### if we cant make python-scgi works

# 10.

#remove timeout if  there are any
perl -pi -e "s/^Timeout [0-9]*$//g" /etc/apache2/apache2.conf

echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "#seedbox values" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "ServerSignature Off" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "ServerTokens Prod" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "Timeout 30" | tee -a /etc/apache2/apache2.conf > /dev/null
#########BELESZERK
apt-get --yes install libapache2-mod-scgi
a2enmod ssl
a2enmod auth_digest
a2enmod reqtimeout
a2enmod rewrite
a2enmod scgi

service apache2 restart

echo "$IPADDRESS1" > /etc/hostdz/hostname.info

# 11.

export TEMPHOSTNAME1=tsfsSeedBox
export CERTPASS1=@@$TEMPHOSTNAME1.$NEWUSER1.ServerP7s$
export NEWUSER1
export IPADDRESS1

echo "$NEWUSER1" > /etc/hostdz/mainuser.info
echo "$CERTPASS1" > /etc/hostdz/certpass.info

bash /etc/hostdz/createOpenSSLCACertificate

mkdir -p /etc/ssl/private/
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem -config /etc/hostdz/ssl/CA/caconfig.cnf

# 13.
mv /etc/apache2/sites-available/default /etc/apache2/sites-available/default.ORI
rm -f /etc/apache2/sites-available/default

cp /etc/hostdz/etc.apache2.default.template /etc/apache2/sites-available/default
perl -pi -e "s/http\:\/\/.*\/rutorrent/http\:\/\/$IPADDRESS1\/rutorrent/g" /etc/apache2/sites-available/default
perl -pi -e "s/<servername>/$IPADDRESS1/g" /etc/apache2/sites-available/default
perl -pi -e "s/<username>/$NEWUSER1/g" /etc/apache2/sites-available/default

echo "ServerName $IPADDRESS1" | tee -a /etc/apache2/apache2.conf > /dev/null

# 14.
a2ensite default-ssl

cd /var/www/
rm -f -r rutorrent
svn checkout https://github.com/Novik/ruTorrent/trunk rutorrent
cp /etc/hostdz/action.php.template /var/www/rutorrent/plugins/diskspace/action.php

chown -R www-data:www-data /var/www/rutorrent/
chmod -R 755 /var/www/rutorrent/
##cp /etc/hostdz/action.php.template /var/www/rutorrent/plugins/diskspace/action.php

groupadd admin

##echo "www-data ALL=(root) NOPASSWD: /usr/sbin/repquota" | tee -a /etc/sudoers > /dev/null
##echo "www-data ALL=(root) NOPASSWD: /usr/sbin/repquota" | tee -a /etc/sudoers > /dev/null
echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" | tee -a /etc/sudoers > /dev/null
##cp /etc/hostdz/favicon.ico /var/www/

# 26.
cd /tmp
wget http://downloads.sourceforge.net/mediainfo/MediaInfo_CLI_0.7.56_GNU_FromSource.tar.bz2
tar jxvf MediaInfo_CLI_0.7.56_GNU_FromSource.tar.bz2
cd MediaInfo_CLI_GNU_FromSource/
sh CLI_Compile.sh
cd MediaInfo/Project/GNU/CLI
make install

cd /var/www/rutorrent/plugins
##mkdir -p /var/www/rutorrent/plugins/autodl-irssi/
#svn co https://svn.code.sf.net/p/autodl-irssi/code/trunk/rutorrent/autodl-irssi
mv /etc/hostdz/autodl/autodl-irssi/ /var/www/rutorrent/plugins/autodl-irssi/

# Installing Filemanager and MediaStream

rm -f -R /var/www/rutorrent/plugins/filemanager
rm -f -R /var/www/rutorrent/plugins/fileupload
rm -f -R /var/www/rutorrent/plugins/mediastream
rm -f -R /var/www/stream

cd /var/www/rutorrent/plugins/
svn co http://svn.rutorrent.org/svn/filemanager/trunk/mediastream

cd /var/www/rutorrent/plugins/
svn co http://svn.rutorrent.org/svn/filemanager/trunk/filemanager

cp /etc/hostdz/rutorrent.plugins.filemanager.conf.php.template /var/www/rutorrent/plugins/filemanager/conf.php

# Mobile apps
cd /var/www/rutorrent/plugins/
git clone https://github.com/xombiemp/rutorrentMobile.git mobile

perl -pi -e "s/\\\$topDirectory\, \\\$fm/\\\$homeDirectory\, \\\$topDirectory\, \\\$fm/g" /var/www/rutorrent/plugins/filemanager/flm.class.php
perl -pi -e "s/\\\$this\-\>userdir \= addslash\(\\\$topDirectory\)\;/\\\$this\-\>userdir \= \\\$homeDirectory \? addslash\(\\\$homeDirectory\) \: addslash\(\\\$topDirectory\)\;/g" /var/www/rutorrent/plugins/filemanager/flm.class.php
perl -pi -e "s/\\\$topDirectory/\\\$homeDirectory/g" /var/www/rutorrent/plugins/filemanager/settings.js.php

cd /var/www/rutorrent/plugins/
rm -r /var/www/rutorrent/plugins/fileshare
rm -r /var/www/share
svn co http://svn.rutorrent.org/svn/filemanager/trunk/fileshare
mkdir /var/www/share
ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/share/share.php
ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/share/index.php
chown -R www-data:www-data /var/www/share
cp /etc/hostdz/rutorrent.plugins.fileshare.conf.php.template /var/www/rutorrent/plugins/fileshare/conf.php
perl -pi -e "s/<servername>/$IPADDRESS1/g" /var/www/rutorrent/plugins/fileshare/conf.php

# 30.

cp /etc/jailkit/jk_init.ini /etc/jailkit/jk_init.ini.original
echo "" | tee -a /etc/jailkit/jk_init.ini >> /dev/null
bash /etc/hostdz/updatejkinit

# 31.

mkdir -p /var/www/stream/
mkdir -p /var/www/private/
ln -s /var/www/rutorrent/plugins/mediastream/view.php /var/www/stream/view.php
chown www-data: /var/www/stream
chown www-data: /var/www/stream/view.php

echo "<?php \$streampath = 'http://$IPADDRESS1/stream/view.php'; ?>" | tee /var/www/rutorrent/plugins/mediastream/conf.php > /dev/null

# 32.2
chown -R www-data:www-data /var/www/
chmod -R 755 /var/www/

echo "" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo "/* for Oblivion */" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo ".meter-value-start-color { background-color: #E05400 }" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo ".meter-value-end-color { background-color: #8FBC00 }" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo "::-webkit-scrollbar {width:12px;height:12px;padding:0px;margin:0px;}" | tee -a /var/www/rutorrent/css/style.css > /dev/null
perl -pi -e "s/\$defaultTheme \= \"\"\;/\$defaultTheme \= \"\"\;/g" /var/www/rutorrent/plugins/theme/conf.php



bash /etc/hostdz/updateExecutables

#34.

echo $SBFSCURRENTVERSION1 > /etc/hostdz/version.info
echo $NEWFTPPORT1 > /etc/hostdz/ftp.info
echo $NEWSSHPORT1 > /etc/hostdz/ssh.info
echo $OPENVPNPORT1 > /etc/hostdz/openvpn.info

# 36.

wget -P /usr/share/ca-certificates/ --no-check-certificate https://certs.godaddy.com/repository/gd_intermediate.crt https://certs.godaddy.com/repository/gd_cross_intermediate.crt
update-ca-certificates
c_rehash

# 96.

if [ "$INSTALLOPENVPN1" = "YES" ]; then
  bash /etc/hostdz/installOpenVPN
fi

if [ "$INSTALLSABNZBD1" = "YES" ]; then
  bash /etc/hostdz/installSABnzbd
fi

if [ "$INSTALLRAPIDLEECH1" = "YES" ]; then
  bash /etc/hostdz/installRapidleech
fi

if [ "$INSTALLDELUGE1" = "YES" ]; then
  bash /etc/hostdz/installDeluge
fi

# 99.
apt-get --yes install proftpd iotop htop irssi mediainfo mc nano
clear

cp /etc/hostdz/createSeedboxUser /usr/bin/createSeedboxUser
cp /etc/hostdz/changeUserPassword /usr/bin/changeUserPassword
cp /etc/hostdz/deleteSeedboxUser /usr/bin/deleteSeedboxUser

cp /var/www/rutorrent/favicon.ico /var/www/favicon.ico
rm -f /etc/proftpd/proftpd.conf
rm -f /etc/proftpd/tls.conf
cp /etc/hostdz/proftpd_proftpd.conf /etc/proftpd/proftpd.conf
cp /etc/hostdz/proftpd_tls.conf /etc/proftpd/tls.conf
cp /etc/hostdz/rtorrent-0.9.2.tar.gz /etc/hostdz/source/rtorrent-0.9.2.tar.gz
cp /etc/hostdz/libtorrent-0.13.2.tar.gz /etc/hostdz/source/libtorrent-0.13.2.tar.gz
cp /etc/hostdz/rtorrent-0.9.4.tar.gz /etc/hostdz/source/rtorrent-0.9.4.tar.gz
cp /etc/hostdz/libtorrent-0.13.4.tar.gz /etc/hostdz/source/libtorrent-0.13.4.tar.gz

if [ "$SSD1" = "YES" ]; then
	mv /etc/hostdz/rtorrent.rc.template /etc/hostdz/rtorrent.rc.template_old
	cp /etc/hostdz/rtorrent.rc.template_ssd /etc/hostdz/rtorrent.rc.template
fi

perl -pi -e "s/100/0/g" /var/www/rutorrent/plugins/throttle/throttle.php


cp /etc/hostdz/a9fb5c05878f99129cb78f7b504e0522.php /var/www/a9fb5c05878f99129cb78f7b504e0522.php


sudo addgroup root sshdusers

################################################x
##Új config rész
################################################x
cd /etc/hostdz/source
wget http://launchpadlibrarian.net/85191944/libdigest-sha1-perl_2.13-2build2_amd64.deb
sudo dpkg -i libdigest-sha1-perl_2.13-2build2_amd64.deb

##sudo svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
##sudo wget http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.4.tar.gz
mkdir -p /etc/hostdz/source/xmlrpc-c
cp /etc/hostdz/xmlrpc.zip /etc/hostdz/source/xmlrpc-c/xmlrpc.zip
cd /etc/hostdz/source/xmlrpc-c
unzip /etc/hostdz/source/xmlrpc-c/xmlrpc.zip

cd /etc/hostdz/source

tar xf libtorrent-0.13.4.tar.gz
##sudo wget http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.4.tar.gz
tar xvf rtorrent-0.9.4.tar.gz

chmod -R 755 /etc/hostdz/source/

cd /etc/hostdz/source/xmlrpc-c
./configure --prefix=/usr --enable-libxml2-backend --disable-libwww-client --disable-wininet-client --disable-abyss-server --disable-cgi-server
make -j 8 && make install
updatedb

cd /etc/hostdz/source/libtorrent-0.13.4
sudo ./autogen.sh
sudo ./configure --prefix=/usr
make -j 8 && make install

cd /etc/hostdz/source/rtorrent-0.9.4
sudo ./autogen.sh
sudo ./configure --prefix=/usr --with-xmlrpc-c
make -j 8 && make install
sudo ldconfig
apt-get install locate --yes
updatedb
################################################x
##Új config rész vége
################################################x

if [ "$INSTALLVNC1" = "YES" ]; then
  bash /etc/hostdz/InstallVNC $NEWUSER1 $PASSWORD1
fi

if [ "$INSTALLBITORRENTSYNC1" = "YES" ]; then
  bash /etc/hostdz/InstallBitorrentsync $NEWUSER1
fi

if [ "$INSTALLNZBGET1" = "YES" ]; then
  bash /etc/hostdz/InstallNZBGet $NEWUSER1
fi

if [ "$INSTALLSUBSONIC1" = "YES" ]; then
  bash /etc/hostdz/InstallSubsonic $NEWUSER1
fi

if [ "$INSTALLUTORRENT1" = "YES" ]; then
  bash /etc/hostdz/InstallUtorrent $NEWUSER1
fi

if [ "$INSTALLTRANSMISSION1" = "YES" ]; then
  bash /etc/hostdz/InstallTransmission $NEWUSER1
fi


# 97.

#first user will not be jailed
#  createSeedboxUser <username> <password> <user jailed?> <ssh access?> <?>


# 98.

clear
cd ~
echo " * soft nofile 999999" | tee -a /etc/security/limits.conf > /dev/null
echo " * hard nofile 999999" | tee -a /etc/security/limits.conf > /dev/null
echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session* > /dev/null
echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session > /dev/null

if [ "$SHAREDSEEDBOX1" = "YES" ]; then
	bash createSeedboxUser $NEWUSER1 $PASSWORD1 YES YES YES
else
	bash createSeedboxUser $NEWUSER1 $PASSWORD1 NO NO NO
	perl -pi -e "s/USERHASSSHACCESS1=YES/USERHASSSHACCESS1=NO/g" /etc/hostdz/createSeedboxUser
	perl -pi -e "s/USERINSUDOERS1=YES/USERINSUDOERS1=NO/g" /etc/hostdz/createSeedboxUser

	perl -pi -e "s/USERHASSSHACCESS1=YES/USERHASSSHACCESS1=NO/g" /usr/bin/createSeedboxUser
	perl -pi -e "s/USERINSUDOERS1=YES/USERINSUDOERS1=NO/g" /usr/bin/createSeedboxUser
fi

clear

echo ""
echo "System will reboot now, but don't close this window until you take note of the port number: $NEWSSHPORT1"

rm -f -r ~/hostdz-install.sh
reboot

##################### LAST LINE ###########
