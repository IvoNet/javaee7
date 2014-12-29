#!/bin/sh
#######################################################################
# Create a domain in glassfish and assign self signed certificates to
# it
#
# By IvoNet.nl
#######################################################################
# Configuration section
#######################################################################
# The glassfhish domain to play around with. If the domain does not
# exist it will be created.
DOMAIN="ivonet"

#Glassfish admin username and password
#If you have not set an ADMIN password in for glassfish please look at
#this blog: http://www.ivonet.it/Linux/Glassfish41
USER="admin"


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
    if [ ! -f "$TEMP_DIR" ]
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
else
    # Creating a new domain to play around with
    asadmin create-domain --adminport 4848 $DOMAIN
fi

echo Copy the default keystore and cacerts to this folder to play around with
cp $GLASSFISH_HOME/glassfish/domains/$DOMAIN/config/keystore.jks ./keystore.jks
cp $GLASSFISH_HOME/glassfish/domains/$DOMAIN/config/cacerts.jks ./cacerts.jks




# Start the newly created domain
gfadmin start-domain $DOMAIN

#Switch a couple of jvm options to point the keystore and truststore to the copied files
asadmin --user $USER --passwordfile ./passwords delete-jvm-options -Djavax.net.ssl.keyStore=\$\{com.sun.aas.instanceRoot\}/config/keystore.jks
asadmin --user $USER --passwordfile ./passwords delete-jvm-options -Djavax.net.ssl.trustStore=\$\{com.sun.aas.instanceRoot\}/config/cacerts.jks

asadmin --user $USER --passwordfile ./passwords create-jvm-options -Djavax.net.ssl.keyStore=`pwd`/keystore.jks
asadmin --user $USER --passwordfile ./passwords create-jvm-options -Djavax.net.ssl.trustStore=`pwd`/cacerts.jks

# See it it worked...
asadmin --user $USER --passwordfile ./passwords list-jvm-options

# Enable the secure admin service
asadmin --user $USER --passwordfile ./passwords  enable-secure-admin

echo "Now you have a working playground domain pointing to a keystore and truststore you can play with"

echo "Creating a certificate"
keytool -genkeypair -alias ivonet -keyalg RSA -keystore keystore.jks -keysize 4096 -dname "cn=localhost, ou=engineering, o=ivonet, c=NL" -keypass changeit -storepass changeit
echo "Created this certificate and added it to keystore.jks"
keytool -list -v -alias ivonet -keystore keystore.jks  -keypass changeit -storepass changeit


# Restart the server
asadmin --user $USER --passwordfile ./passwords restart-domain $DOMAIN

#echo cleanup
rm -f ./passwords
clear




