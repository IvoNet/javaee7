#!/bin/sh
clear
#######################################################################
# Create a domain in glassfish and assign self signed certificates to
# it.
#
# RUN THIS SCRIPT AT YOUR OWN RISK! I WROTE IT FOR A MAC WITH GLASSFISH
# INSTALLED THROUGH HOMEBREW. PLEASE CHECK EVERYTHING FIRST BEFORE
# RUNNING IT. THE KNWOLEDGE WITHIN MIGHT BE USEFUL THOUGH.
#
# By IvoNet.nl
#######################################################################
# Configuration section
#######################################################################
# The glassfhish domain to play around with. If the domain does not
# exist it will be created.
DOMAIN="ivonet"

#Glassfish admin username and password
#If you have not set an ADMIN password for glassfish please look at
#this blog: http://www.ivonet.it/Linux/Glassfish41
USER="admin"

#The owner for the certificate
OWNER="IvoNet"

# The alias used for the certificate import (use no spaces!)
CERTIFICATE_ALIAS="ivonet"


#The word used of creating the secure http-listener and other items needed in glassfish.
#It is just an identifier and may not contain spaces
SECURE_HTTP_LISTENER_PROTOCOL="ivonet"

#######################################################################
# Application section - Edit at your own discretion
#######################################################################
# Die function
die () {
    echo >&2 "[ERROR] The job ended in error."
    echo "[MSG] $@"
    exit 1
}

gfadmin() {
    if [ ! -f "./passwords" ]
    then
        read -s -p "Enter Glassfish Password: " mypassword
        #AS_ADMIN_MASTERPASSWORD
        #AS_ADMIN_USERPASSWORD
        #AS_ADMIN_ALIASPASSWORD
        echo AS_ADMIN_PASSWORD=$mypassword>./passwords
    fi

    asadmin --user $USER --passwordfile ./passwords $@
}

if [ "$GLASSFISH_HOME" = "" ]
then
    die "GLASSFISH_HOME has not been set.\nPlease make sure glassfish has been installed and the environment has been set up correctly."
fi

# Stop the current domain of it runs
asadmin stop-domain domain1

echo "Checking of your domain already exists in the domains list"

DOMAINA=`asadmin list-domains|grep $DOMAIN`
echo $DOMAINA
if [ ! "$DOMAINA" = "" ]
then
    echo "The domain you are trying to create already exists. Skipping"
    gfadmin stop-domain $DOMAIN
    gfadmin delete-domain $DOMAIN
fi

    # Creating a new domain to play around with
gfadmin create-domain --adminport 4848 $DOMAIN

echo Copy the default keystore and cacerts to this folder to play around with
cp $GLASSFISH_HOME/glassfish/domains/$DOMAIN/config/keystore.jks ./keystore.jks
cp $GLASSFISH_HOME/glassfish/domains/$DOMAIN/config/cacerts.jks ./cacerts.jks

echo "Creating a certificate"
#keytool -genkeypair -alias ivonet -keyalg RSA -keystore keystore.jks -keysize 4096 -dname "cn=localhost, ou=engineering, o=$OWNER, c=NL" -keypass changeit -storepass changeit
keytool -genkey -alias $CERTIFICATE_ALIAS -keyalg RSA -keystore keystore.jks -keysize 4096 -dname "cn=localhost, ou=engineering, o=$OWNER, c=NL" -keypass changeit -storepass changeit
keytool -export -alias $CERTIFICATE_ALIAS -file server.cer -keystore keystore.jks -keypass changeit -storepass changeit
keytool -import -v -trustcacerts -alias $CERTIFICATE_ALIAS -file server.cer -keystore cacerts.jks -keypass changeit -storepass changeit -noprompt
echo "Created this certificate and added it to keystore.jks"
keytool -list -v -alias $CERTIFICATE_ALIAS -keystore keystore.jks  -keypass changeit -storepass changeit

#keytool -export  -keystore keystore.jks -keypass changeit -storepass changeit -alias #CERTIFICATE_ALIAS -file client.cer
#keytool -printcert  -file client.cer  -v
sudo keytool -delete -noprompt -alias $CERTIFICATE_ALIAS -keystore /Library/Java/Home/lib/security/cacerts -keypass changeit -storepass changeit
sudo keytool -trustcacerts -import -alias $CERTIFICATE_ALIAS -file server.cer -keystore /Library/Java/Home/lib/security/cacerts -noprompt


RUNNING=`asadmin list-domains|grep $DOMAIN`
echo $RUNNING
if [ "$RUNNING" = "$DOMAIN not running" ]
then
    gfadmin start-domain $DOMAIN
fi

#Switch a couple of jvm options to point the keystore and truststore to the copied files
#Start using the copied stores. I don't want to mess with the origionals.
gfadmin delete-jvm-options -Djavax.net.ssl.keyStore=\$\{com.sun.aas.instanceRoot\}/config/keystore.jks
gfadmin delete-jvm-options -Djavax.net.ssl.trustStore=\$\{com.sun.aas.instanceRoot\}/config/cacerts.jks

gfadmin create-jvm-options -Djavax.net.ssl.keyStore=`pwd`/keystore.jks
gfadmin create-jvm-options -Djavax.net.ssl.trustStore=`pwd`/cacerts.jks

# See it it worked...
gfadmin list-jvm-options

# Enable the secure admin service
gfadmin enable-secure-admin

# Restart the server
gfadmin restart-domain $DOMAIN

#gfadmin delete-network-listener ivonet-listener
#gfadmin delete-protocol ivonet-protocol
#gfadmin delete-http ivonet-protocol

gfadmin create-protocol --securityenabled=true $SECURE_HTTP_LISTENER_PROTOCOL-protocol
gfadmin create-http --timeout-seconds 60 --default-virtual-server server $SECURE_HTTP_LISTENER_PROTOCOL-protocol
gfadmin create-threadpool --maxthreadpoolsize 100 --minthreadpoolsize 20 --idletimeout 2 $SECURE_HTTP_LISTENER_PROTOCOL-threadpool
gfadmin create-network-listener --listenerport 7272 --protocol $SECURE_HTTP_LISTENER_PROTOCOL-protocol --enabled=true --threadpool $SECURE_HTTP_LISTENER_PROTOCOL-threadpool $SECURE_HTTP_LISTENER_PROTOCOL-listener
gfadmin create-ssl --type http-listener --certname $CERTIFICATE_ALIAS --ssl3enabled=false $SECURE_HTTP_LISTENER_PROTOCOL-listener

# Restart the server
gfadmin restart-domain $DOMAIN


#cleanup stuff
rm -f ./passwords


clear
echo "-------------------------------------------------------------------------------------------------"
echo "finished."
echo "-------------------------------------------------------------------------------------------------"
echo "Now you have a working playground domain pointing to a keystore and truststore you can play with"
echo "Open the browser at https://localhost:7272 and see what happends (look at the certificate)"
echo "-------------------------------------------------------------------------------------------------"
