#!/bin/sh

echo;
echo "Installing MultiNest-REAP ...";
echo;

chmod a+x ./runMath
cp -pR ./runMath /usr/local/bin/

echo;
echo "Installing REAP ...";
echo;

bash ./reap_package/install.sh

echo;
echo "Preparing examples ...";
echo;

cp -pR ./examples/HSMU_REAP.m ~/.Mathematica/Applications/


