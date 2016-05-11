#!/bin/bash

# set -x


# Program information
#releasedate="11 May 2016"
#author="Richardson Lima"
#author_contact="contato@richardsonlima.com.br"
#website="http://www.richardsonlima.com.br"
#copyright="Copyright 2006"

# ./ZimbraEasyInstall zimbralab.local 192.168.x.y Zimbra2016
# Web Client - https://YOURIP
# Admin Console - https://YOURIP:7071

## Preparing all the variables like IP, Hostname, etc, all of them from the container
RANDOMHAM=$(date +%s|sha256sum|base64|head -c 10)
RANDOMSPAM=$(date +%s|sha256sum|base64|head -c 10)
RANDOMVIRUS=$(date +%s|sha256sum|base64|head -c 10)

DnsInstall(){ #Install a DNS Server and Zimbra Collaboration 8.6
echo -e '\033[1;32m [✔] Installing DNS Server \033[0m'
sudo apt-get update && sudo sudo apt-get install -y bind9 bind9utils bind9-doc
echo -e '\033[1;32m [✔] Configuring DNS Server \033[0m'
sudo sed "s/-u/-4 -u/g" /etc/default/bind9 > /etc/default/bind9.new
sudo mv /etc/default/bind9.new /etc/default/bind9
HOSTNAME=$(hostname -a)
sudo rm /etc/bind/named.conf.options
sudo cat <<EOF >>/etc/bind/named.conf.options
options {
directory "/var/cache/bind";
listen-on { $2; }; # ns1 private IP address - listen on private network only
allow-transfer { none; }; # disable zone transfers by default
forwarders {
8.8.8.8;
8.8.4.4;
};
auth-nxdomain no; # conform to RFC1035
#listen-on-v6 { any; };
};
EOF
sudo cat <<EOF >>/etc/bind/named.conf.local
zone "$1" {
        type master;
        file "/etc/bind/db.$1";
};
EOF
sudo touch /etc/bind/db.$1
sudo cat <<EOF >/etc/bind/db.$1
\$TTL  604800
@      IN      SOA    ns1.$1. root.localhost. (
                              2        ; Serial
                        604800        ; Refresh
                          86400        ; Retry
                        2419200        ; Expire
                        604800 )      ; Negative Cache TTL
;
@     IN      NS      ns1.$1.
@     IN      A      $2
@     IN      MX     10     $HOSTNAME.$1.
$HOSTNAME     IN      A      $2
ns1     IN      A      $2
mail     IN      A      $2
pop3     IN      A      $2
imap     IN      A      $2
imap4     IN      A      $2
smtp     IN      A      $2
EOF
sudo service bind9 restart
}

CreateZimbraEnv(){
echo -e '\033[1;32m [✔] Download and install Zimbra Collaboration dependencies \033[0m'
sudo apt-get install -y netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libperl5.18 libaio1 resolvconf unzip pax sysstat sqlite3
echo -e '\033[1;32m [✔] Creating the Scripts files \033[0m'
sudo mkdir /tmp/zcs && cd /tmp/zcs
sudo touch /tmp/zcs/installZimbraScript
sudo cat <<EOF >/tmp/zcs/installZimbraScript
AVDOMAIN="$1"
AVUSER="admin@$1"
CREATEADMIN="admin@$1"
CREATEADMINPASS="$3"
CREATEDOMAIN="$1"
DOCREATEADMIN="yes"
DOCREATEDOMAIN="yes"
DOTRAINSA="yes"
EXPANDMENU="no"
HOSTNAME="$HOSTNAME.$1"
HTTPPORT="8080"
HTTPPROXY="TRUE"
HTTPPROXYPORT="80"
HTTPSPORT="8443"
HTTPSPROXYPORT="443"
IMAPPORT="7143"
IMAPPROXYPORT="143"
IMAPSSLPORT="7993"
IMAPSSLPROXYPORT="993"
INSTALL_WEBAPPS="service zimlet zimbra zimbraAdmin"
JAVAHOME="/opt/zimbra/java"
LDAPAMAVISPASS="$3"
LDAPPOSTPASS="$3"
LDAPROOTPASS="$3"
LDAPADMINPASS="$3"
LDAPREPPASS="$3"
LDAPBESSEARCHSET="set"
LDAPHOST="$HOSTNAME.$1"
LDAPPORT="389"
LDAPREPLICATIONTYPE="master"
LDAPSERVERID="2"
MAILBOXDMEMORY="972"
MAILPROXY="TRUE"
MODE="https"
MYSQLMEMORYPERCENT="30"
POPPORT="7110"
POPPROXYPORT="110"
POPSSLPORT="7995"
POPSSLPROXYPORT="995"
PROXYMODE="https"
REMOVE="no"
RUNARCHIVING="no"
RUNAV="yes"
RUNCBPOLICYD="no"
RUNDKIM="yes"
RUNSA="yes"
RUNVMHA="no"
SERVICEWEBAPP="yes"
SMTPDEST="admin@$1"
SMTPHOST="$HOSTNAME.$1"
SMTPNOTIFY="yes"
SMTPSOURCE="admin@$1"
SNMPNOTIFY="yes"
SNMPTRAPHOST="$HOSTNAME.$1"
SPELLURL="http://$HOSTNAME.$1:7780/aspell.php"
STARTSERVERS="yes"
SYSTEMMEMORY="3.8"
TRAINSAHAM="ham.$RANDOMHAM@$1"
TRAINSASPAM="spam.$RANDOMSPAM@$1"
UIWEBAPPS="yes"
UPGRADE="yes"
USESPELL="yes"
VERSIONUPDATECHECKS="TRUE"
VIRUSQUARANTINE="virus-quarantine.$RANDOMVIRUS@$1"
ZIMBRA_REQ_SECURITY="yes"
ldap_bes_searcher_password="$3"
ldap_dit_base_dn_config="cn=zimbra"
ldap_nginx_password="$3"
mailboxd_directory="/opt/zimbra/mailboxd"
mailboxd_keystore="/opt/zimbra/mailboxd/etc/keystore"
mailboxd_keystore_password="$3"
mailboxd_server="jetty"
mailboxd_truststore="/opt/zimbra/java/jre/lib/security/cacerts"
mailboxd_truststore_password="changeit"
postfix_mail_owner="postfix"
postfix_setgid_group="postdrop"
ssl_default_digest="sha256"
zimbraFeatureBriefcasesEnabled="Enabled"
zimbraFeatureTasksEnabled="Enabled"
zimbraIPMode="ipv4"
zimbraMailProxy="FALSE"
zimbraMtaMyNetworks="127.0.0.0/8 $2/24 [::1]/128 [fe80::]/64"
zimbraPrefTimeZoneId="America/Recife"
zimbraReverseProxyLookupTarget="TRUE"
zimbraVersionCheckNotificationEmail="admin@$1"
zimbraVersionCheckNotificationEmailFrom="admin@$1"
zimbraVersionCheckSendNotifications="TRUE"
zimbraWebProxy="FALSE"
zimbra_ldap_userdn="uid=zimbra,cn=admins,cn=zimbra"
zimbra_require_interprocess_security="1"
INSTALL_PACKAGES="zimbra-core zimbra-ldap zimbra-logger zimbra-mta zimbra-snmp zimbra-store zimbra-apache zimbra-spell zimbra-memcached zimbra-proxy"
EOF
touch /tmp/zcs/installZimbra-keystrokes
cat <<EOF >/tmp/zcs/installZimbra-keystrokes
y
y
y
y
n
y
y
y
y
y
y
y
EOF
}

DownloadZimbra(){
echo -e '\033[1;32m [✔] Downloading Zimbra Collaboration 8.6 \033[0m'
wget https://files.zimbra.com/downloads/8.6.0_GA/zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116.tgz
tar xzvf zcs-*
}
InstallZimbra(){
echo -e '\033[1;32m [✔] Installing Zimbra Collaboration just the Software \033[0m'
cd /tmp/zcs/zcs-* && sudo ./install.sh -s < /tmp/zcs/installZimbra-keystrokes
echo -e '\033[1;32m [✔] Installing Zimbra Collaboration injecting the configuration \033[0m'
sudo /opt/zimbra/libexec/zmsetup.pl -c /tmp/zcs/installZimbraScript
}
#####

DnsInstall
CreateZimbraEnv
DownloadZimbra
InstallZimbra
