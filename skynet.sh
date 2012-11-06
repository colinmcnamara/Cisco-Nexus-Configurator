#!/bin/sh

# skynet.sh
# Nexus Autotester
#
# Created by Colin McNamara on 2/24/11.
# Copyright 2011 __MyCompanyName__. All rights reserved.
OIFS=$IFS
IFS=,
version=v1.4
# test for the required local directories
# if they don't exist create them
##### run this as root #####


if [ -d tmp ]
then
	echo "******************************************"
	echo " temp directory found "
else
mkdir tmp
fi

if [ -d testing-output ]
then
	echo "******************************************"
	echo " testing output  directory found "
	mv testing-output/* *.bak
	echo " cleaning out testing directory "

else
mkdir tmp
fi


if [ -f interface-assignments.csv ]
then 
	echo "******************************************"
	echo " interface-assigments.csv file  found "
else 
	echo "******************************************"
	echo " please create interface-assigments.csv and place in the same directory as this script"
fi
	echo "******************************************"
	Echo "copying /etc/hosts to /etc/hosts.bak"
	cp /etc/hosts /etc/hosts.skynet.bak
if [ -f /etc/hosts.orig.bak ]
then
	echo "******************************************"
	echo " original hosts backup found " 
else
	cp /etc/hosts /etc/hosts.orig.bak
fi 	
	echo "******************************************"
	Echo "appending target hosts file to /etc/hosts"

	cat tmp/hosts.skynet.tmp.txt >> /etc/hosts 

# put the version number into VERSION.TXT
echo "Version $version" > VERSION-SKYNET.TXT

# remove the first line off interface-assignments.csv, copy it to a file in the tmp directory
awk '{if (NR!=1) {print}}' interface-assignments.csv > ./tmp/stripped.interface-assignments.csv.tmp.txt

# match the following field descriptions to your CSV file column names
while read srcsys site cell zone tile type nodenum vdcid srcpo srcchannelgroup srcipaddress subnetmask srcmemberint dstsys dstmemberint defaultgw ospfarea nativevlan allowdvlans vlanid vpcid mtu l2po l2pomember l3po l3pomember vpcpo vpcpomember peerlinkpo peerlinkpomember peerkeepalivelink peerkeepalivelinkmember mgmt loopback vpca vpcb hsrpa hsrpb tacacs n7k n5k fexpo fexpomember
do
#fping -p 100 -c 10 -q  10.0.76.1 
# be sure to suid root to skynet.sh
# to set the userid as root, log in as root 
# example sudo su - 
# chmod 4755 ** 
# ping must be run as root for visibility lower then 1 second
# let's run this using fping later, and figure out the summary output issues.

echo "###############################"
echo " "
echo "starting ping"
echo " "

ping -q -c 5 -i .1 $srcsys.vdc$vdcid | awk '/packets/' | awk '{ print " $srcsys , $vdcid , $srcmemeberint , " $1 - $4  }' >> ./testing-output/down-test.tmp.txt &

echo "###############################"
echo " "
echo "bringing down interface"
echo " "
# future - concatenate $srcssystem.$vdc into a hosts file (back up /etc/hosts cat blah.txt >> /etc/hosts
# ./ifup.exp colin 1Cisco123 $srcssystem.$vdc $srcmememberint 
./ifdown.exp colin 1Cisco123 $srcsys.vdc$vdcid $srcmemberint

echo "###############################"
echo " "
echo "sleeping 5 seconds to wait for convergence"
echo " "
sleep 5

echo "###############################"
echo " "
echo "starting ping"
echo " "
# change the output file to $srcssystem.$vdc.something.txt pipe to sed / awk to grap missed packets and putput in csv. Stack the csv lines together to creat output spreadsheet.
ping -q -c 5 -i .1 $srcsys.vdc$vdcid | awk '/packets/' | awk '{ print " $srcsys , $vdcid , $srcmemeberint , " $1 - $4  }' >> ./testing-output/up-test.tmp.txt &
echo "###############################"
echo " "
echo "bringing up interface"
echo " "
./ifup.exp colin 1Cisco123 $srcsys.vdc$vdcid $srcmemberint
echo "###############################"
echo " "
echo " sleeping 5 seconds to wait for convergence"
echo " "
sleep 5

echo "###############################"
echo " "
echo "test complete"
echo " "

#return /etc/hosts to how we found it
cp /etc/hosts.skynet.bak /etc/hosts

#end the while loop reading in file
done < ./tmp/stripped.interface-assignments.csv.tmp.txt