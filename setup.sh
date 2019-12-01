#!/bin/sh

echo;
echo "Installing MultiNest-REAP ...";
echo;

chmod a+x ./runMath
cp ./runmMath /usr/local/bin/

echo;
echo "Installing REAP ...";
echo;

bash ./reap_package/install.sh




