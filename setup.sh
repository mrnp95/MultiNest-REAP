#!/bin/sh

echo;
echo "Installing MultiNest-REAP ...";
echo;

chmod +x ./runMath
cp -pR ./runMath /usr/local/bin/

echo "Done!"
echo;
echo "Installing REAP ...";
echo;

bash ./reap_package/install.sh

echo "Done!"
echo;
echo "Preparing examples ...";
echo;

cp -pR ./examples/HSMU_REAP.m ~/.Mathematica/Applications/

echo "Done!"

