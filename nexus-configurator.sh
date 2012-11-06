#!/bin/sh
#
# nexus-configurator.sh
# 
# Created by Colin McNamara on 2/13/11.
# Copyright 2011 Colin McNamara. All rights reserved.
# http://www.colinmcnamara.com colin@2cups.com http://www.twitter.com/colinmcnamara

OIFS=$IFS
IFS=,
version=v2.6
# test for the required local directories
# if they don't exist create them

if [ -d config-output ]  
then 
	echo "******************************************"
	echo " config-output directory found "
	rm -rf config-output/*.txt
	echo " cleaning out config-output directory "
	
else
mkdir config-output
fi 

if [ -d tmp ]
then
	echo "******************************************"
	echo " temp directory found "
	rm -rf tmp/*.txt
	echo " cleaning out temp directory "

else
mkdir .tmp
fi


if [ -d config-elements ]
then 
	echo "******************************************"
	echo " config-elements directory found "
	rm -rf config-elements/*.txt
	echo " cleaning out config-elements directory "
else 
mkdir config-elements
fi

if [ -f interface-assignments.csv ]
then 
	echo "******************************************"
	echo " interface-assigments.csv file  found "
else 
	echo "******************************************"
	echo " please create interface-assigments.csv and place in the same directory as this script"
fi

# put the version number into VERSION.TXT
echo "Version $version" > VERSION.TXT

# match the following field descriptions to your CSV file column names
while read srcsys site cell zone tile type nodenum vdcid srcpo srcchannelgroup srcipaddress subnetmask srcmemberint dstsys dstmemberint defaultgw ospfarea nativevlan allowdvlans vlanid vpcid mtu l2po l2pomember l3po l3pomember vpcpo vpcpomember peerlinkpo peerlinkpomember peerkeepalivelink peerkeepalivelinkmember mgmt loopback vpca vpcb hsrpa hsrpb tacacs n7k n5k fexpo fexpomember

do
  echo "******************************************"
  echo "srcsys      -> [${srcsys}]"
  echo "site     -> [${site}]"
  echo "cell     -> [${cell}]"
  echo "zone     -> [${zone}]"
  echo "tile     -> [${tile}]"
  echo "type     -> [${type}]"
  echo "nodenum     -> [${vdcid}]"
  echo "vdcid     -> [${vdcid}]"
  echo "srcpo      -> [${srcpo}]"
  echo "srcchannelgroup   -> [${srcchannelgroup}]"
  echo "srcipaddress -> [${srcipaddress}]"
  echo "subnetmask -> [${subnetmask}]"
  echo "srcmemberint     -> [${srcmemberint}]"
  echo "dstsys     -> [${dstsys}]"
  echo "dstmemberint     -> [${dstmemberint}]"
  echo "defaultgw     -> [${defaultgw}]"
  echo "nativevlan     -> [${nativevlan}]"
  echo "ospfarea     -> [${ospfarea}]"
  echo "allowedvlan     -> [${allowedvlan}]"
  echo "vlanid     -> [${vlanid}]"
  echo "vpcid     -> [${vpcid}]"
  echo "mtu     -> [${mtu}]"
  echo "l2po     -> [${l2po}]"
  echo "l2pomember     -> [${l2pomember}]"
  echo "l3po     -> [${l3po}]"
  echo "l3pomember     -> [${l3pomember}]"
  echo "vpcpo     -> [${vpcpo}]"
  echo "vpcpomember     -> [${vpcpomember}]"
  echo "peerlinkpo     -> [${peerlinkpo}]"
  echo "peerlinkpomember     -> [${peerlinkpomember}]"
  echo "peerkeepalivelink     -> [${peerkeepalivelink}]"  
  echo "peerkeepalivelinkmember     -> [${peerkeepalivelinkmember}]"
  echo "mgmt     -> [${mgmt}]"
  echo "loopback     -> [${loopback}]"  
  echo "vpca     -> [${vpca}]"
  echo "vpcb     -> [${vpcb}]"
  echo "hsrpa     -> [${hsrpa}]"
  echo "hsrpb     -> [${hsrpb}]"
  echo "tacacs     -> [${tacacs}]"
  echo "n7k     -> [${n7k}]"
  echo "n5k     -> [${n5k}]"
  echo "fexpo     -> [${fexpo}]"
  echo "fexpomember     -> [${fexpomember}]"
        
if [ "$mgmt" == "TRUE" ] && [ "$vdcid" == "1" ]
then
  #create the base config
  #move all interfaces into vdc 2
  
  echo "
  hostname $srcsys-rootvdc
  
  vdc $srcsys-rootvdc id 1
  limit-resource vlan minimum 16 maximum 4094
  limit-resource monitor-session minimum 0 maximum 2
  limit-resource monitor-session-erspan-dst minimum 0 maximum 23
  limit-resource vrf minimum 2 maximum 1000
  limit-resource port-channel minimum 0 maximum 768
  limit-resource u4route-mem minimum 96 maximum 96
  limit-resource u6route-mem minimum 24 maximum 24
  limit-resource m4route-mem minimum 58 maximum 58
  limit-resource m6route-mem minimum 8 maximum 8

  vdc $srcsys id 2
  limit-resource vlan minimum 16 maximum 4094
  limit-resource monitor-session minimum 0 maximum 2
  limit-resource monitor-session-erspan-dst minimum 0 maximum 23
  limit-resource vrf minimum 2 maximum 1000
  limit-resource port-channel minimum 0 maximum 768
  limit-resource u4route-mem minimum 96 maximum 96
  limit-resource u6route-mem minimum 24 maximum 24
  limit-resource m4route-mem minimum 58 maximum 58
  limit-resource m6route-mem minimum 8 maximum 8
  
  
allocate interface ethernet 1/1-8
 
allocate interface ethernet 2/1-8

allocate interface ethernet 3/1-8

allocate interface ethernet 4/1-32

allocate interface ethernet 5/1-32

allocate interface ethernet 6/1-32

allocate interface ethernet 7/1-32

allocate interface ethernet 8/1-32

allocate interface ethernet 11/1-48

allocate interface ethernet 12/1-48

allocate interface ethernet 13/1-48


  vdc $srcsys-otv id 3
  limit-resource vlan minimum 16 maximum 4094
  limit-resource monitor-session minimum 0 maximum 2
  limit-resource monitor-session-erspan-dst minimum 0 maximum 23
  limit-resource vrf minimum 2 maximum 1000
  limit-resource port-channel minimum 0 maximum 768
  limit-resource u4route-mem minimum 96 maximum 96
  limit-resource u6route-mem minimum 24 maximum 24
  limit-resource m4route-mem minimum 58 maximum 58
  limit-resource m6route-mem minimum 8 maximum 8
  
  no vdc combined-hostname
  
  cfs eth distribute
  feature ospf
  feature private-vlan
  feature udld
  feature interface-vlan
  feature hsrp
  feature lacp
  feature lldp
  
  username colin role network-admin password 1Cisco123
  ip domain-lookup
  system jumbomtu 9000
  ntp server 192.43.244.18 use-vrf management
  ntp server 192.43.244.18 use-vrf management
  clock timezone GMT 0 0
  clock summer-time MDT
  cli alias name wri copy run start 
  cli alias name wr copy run start
  cli alias name swt switchto vdc
  line console
  line vty
  logging logfile LOG-FILE 7 size 64000
  logging server 1.1.1.1 5 use-vrf management
  logging timestamp microseconds
  logging level local7 6
  
snmp-server community readonly ro
snmp-server community readwrite rw
snmp-server host 1.1.1.1 password
snmp-server host 1.1.1.1 traps password
snmp-server host 1.1.1.1 source-interface mgmt 0
snmp-server host 1.1.1.1 use-vrf management 

snmp-server enable traps feature-control FeatureOpStatusChange
snmp-server enable traps rmon risingAlarm
snmp-server enable traps rmon fallingAlarm
snmp-server enable traps rmon hcRisingAlarm
snmp-server enable traps rmon hcFallingAlarm
snmp-server enable traps config ccmCLIRunningConfigChanged
snmp-server enable traps snmp authentication
 " >> ./config-elements/$srcsys.vdc1.a1.base-config.tmp.txt

fi 

if [ "$mgmt" == "TRUE" ] && [ "$vdcid" == "2" ]
then
echo "  
  end
  
  switchback
  
  switchto vdc $srcsys
  
  config t
  hostname $srcsys
 
  cfs eth distribute
  feature ospf
  feature private-vlan
  feature udld
  feature interface-vlan
  feature hsrp
  feature lacp
  feature lldp
  
  username colin role network-admin password 1Cisco123
  ip domain-lookup
  system jumbomtu 9000
  ntp server 192.43.244.18 use-vrf management
  ntp server 192.43.244.18 use-vrf management
  clock timezone GMT 0 0
  clock summer-time MDT
  cli alias name wri copy run start 
  cli alias name wr copy run start
  cli alias name swt switchto vdc
  line console
  line vty
  logging logfile LOG-FILE 7 size 64000
  logging server 1.1.1.1 5 use-vrf management
  logging timestamp microseconds
  logging level local7 6
  
snmp-server community readonly ro
snmp-server community readwrite rw
snmp-server host 1.1.1.1 password
snmp-server host 1.1.1.1 traps password
snmp-server host 1.1.1.1 source-interface mgmt 0
snmp-server host 1.1.1.1 use-vrf management 

snmp-server enable traps feature-control FeatureOpStatusChange
snmp-server enable traps rmon risingAlarm
snmp-server enable traps rmon fallingAlarm
snmp-server enable traps rmon hcRisingAlarm
snmp-server enable traps rmon hcFallingAlarm
snmp-server enable traps config ccmCLIRunningConfigChanged
snmp-server enable traps snmp authentication

  " >> ./config-elements/$srcsys.vdc2.a2.base-config.tmp.txt 

fi 
# pop out base config for OTV VDC
if [ "$mgmt" == "TRUE" ] && [ "$vdcid" == "3" ]
then
echo "  
  end
  
  switchback
  
  switchto vdc $srcsys-otv
  
  
  config t
  hostname $srcsys-otv

  cfs eth distribute
  feature ospf
  feature private-vlan
  feature udld
  feature interface-vlan
  feature hsrp
  feature lacp
  feature lldp
  feature otv
  
  username colin role network-admin password 1Cisco123
  ip domain-lookup
  system jumbomtu 9000
  ntp server 192.43.244.18 use-vrf management
  ntp server 192.43.244.18 use-vrf management
  clock timezone GMT 0 0
  clock summer-time MDT
  cli alias name wri copy run start 
  cli alias name wr copy run start
  cli alias name swt switchto vdc
  line console
  line vty
  logging logfile LOG-FILE 7 size 64000
  logging server 1.1.1.1 5 use-vrf management
  logging timestamp microseconds
  logging level local7 6
  
snmp-server community readonly ro
snmp-server community readwrite rw
snmp-server host 1.1.1.1 password
snmp-server host 1.1.1.1 traps password
snmp-server host 1.1.1.1 source-interface mgmt 0
snmp-server host 1.1.1.1 use-vrf management 

snmp-server enable traps feature-control FeatureOpStatusChange
snmp-server enable traps rmon risingAlarm
snmp-server enable traps rmon fallingAlarm
snmp-server enable traps rmon hcRisingAlarm
snmp-server enable traps rmon hcFallingAlarm
snmp-server enable traps config ccmCLIRunningConfigChanged
snmp-server enable traps snmp authentication

!end
!switchback
  " >> ./config-elements/$srcsys.vdc3.a3.base-config.tmp.txt 
  
fi 

# create base config for n5k
if [ "$mgmt" == "TRUE" ] && [ "$n5k" == "TRUE" ]
then
echo "  
   config t
  hostname $srcsys

feature telnet
cfs eth distribute
feature interface-vlan
feature lacp
feature vpc
feature fex
  
  username colin role network-admin password 1Cisco123
  ip domain-lookup
  system jumbomtu 9000
  cli alias name wri copy run start 
  cli alias name wr copy run start
  cli alias name swt switchto vdc
  line console
  line vty
  logging logfile LOG-FILE 7 size 64000
  logging server 1.1.1.1 5 use-vrf management
  logging server 1.1.1.1 5 use-vrf management
  logging server 1.1.1.1 5 use-vrf management
  logging timestamp microseconds
  logging level local7 6

snmp-server community readonly ro
snmp-server community readwrite rw
snmp-server host 1.1.1.1 password
snmp-server host 1.1.1.1 traps password
snmp-server host 1.1.1.1 source-interface mgmt 0
snmp-server host 1.1.1.1 use-vrf management 

snmp-server enable traps feature-control FeatureOpStatusChange
snmp-server enable traps rmon risingAlarm
snmp-server enable traps rmon fallingAlarm
snmp-server enable traps rmon hcRisingAlarm
snmp-server enable traps rmon hcFallingAlarm
snmp-server enable traps config ccmCLIRunningConfigChanged
snmp-server enable traps snmp authentication


policy-map type network-qos jumbo
class type network-qos class-default
mtu 9000
system qos
service-policy type network-qos jumbo


  " >> ./config-elements/$srcsys.vdc$vdcid.a1.base-config.tmp.txt 
  
fi 


if [ "$l3pomember" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint
  mtu $mtu
  logging event port link-status
  udld aggressive
!  rate-mode dedicated force
  channel-group $srcchannelgroup mode active
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.c1.l3pomember.tmp.txt 
fi  

if [ "$l3po" == "TRUE" ]
then
  echo "
  interface po$srcchannelgroup
  description l3-link to $dstsys 
  logging event port link-status
  mtu $mtu
  ip address $srcipaddress$subnetmask
  ip ospf dead-interval 3
  ip ospf hello-interval 1
  ip ospf network point-to-point
  ip router ospf 1 area $ospfarea
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b1.l3po.tmp.txt 
fi  
# N7K PEER LINK CONFIGS
if [ "$peerlinkpomember" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  switchport
  switchport mode trunk
  switchport trunk native vlan $nativevlan
!  rate-mode dedicated force
  mtu $mtu
  channel-group $srcchannelgroup mode active
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.c2.l2peerlinkmember.tmp.txt 
fi

if [ "$peerlinkpo" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  switchport
  switchport mode trunk
  switchport trunk native vlan $nativevlan
  switchport trunk allowed vlan 1-4093
  switchport trunk allowed vlan remove 2
  spanning-tree port type network
  mtu $mtu
  vpc peer-link
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b2.lpeerlinkpo.tmp.txt 
fi 

## N5K PEER LINK CONFIGS
if [ "$peerlinkpomember" == "TRUE" ]  && [ "$n5k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  switchport mode trunk
  switchport trunk native vlan $nativevlan
  switchport trunk allowed vlan 1-4093
  switchport trunk allowed vlan remove 2
  channel-group $srcchannelgroup mode active
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.c2.l2peerlinkmember.tmp.txt 
fi

if [ "$peerlinkpo" == "TRUE" ]  && [ "$n5k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  switchport mode trunk
  switchport trunk native vlan $nativevlan
  switchport trunk allowed vlan 1-4093
  switchport trunk allowed vlan remove 2
  spanning-tree port type network
  vpc peer-link
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b2.lpeerlinkpo.tmp.txt 
fi 


## N7K vpc po config
if [ "$vpcpomember" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  switchport
  switchport mode trunk
  switchport trunk native vlan $nativevlan
  switchport trunk allowed vlan 1-4093
  
  switchport trunk allowed vlan remove 2
  
  mtu $mtu
  channel-group $srcchannelgroup mode active
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.c2.vpcpomember.tmp.txt 
fi

if [ "$vpcpo" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint
  switchport 
  switchport mode trunk
  switchport trunk native vlan $nativevlan
  switchport trunk allowed vlan 1-4093
  
  switchport trunk allowed vlan remove 2
  
  mtu $mtu
  vpc $vpcid
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b2.vpcpo.tmp.txt 
fi 
## N5K vpc po config
if [ "$vpcpomember" == "TRUE" ]  && [ "$n5k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  switchport mode trunk
  switchport trunk native vlan $nativevlan
  switchport trunk allowed vlan 1-4093
  
  switchport trunk allowed vlan remove 2
  
  channel-group $srcchannelgroup mode active
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.c2.vpcpomember.tmp.txt 
fi

if [ "$vpcpo" == "TRUE" ]  && [ "$n5k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  vpc $vpcid
  switchport mode trunk
  switchport trunk native vlan $nativevlan
  switchport trunk allowed vlan 1-4093
  
  switchport trunk allowed vlan remove 2
  

  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b2.vpcpo.tmp.txt 
fi 

## Fex po member  po config with fex attatched
if [ "$n5k" == "TRUE" ]  && [ "$fexpomember" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  fex associate $vpcid
  switchport mode fex-fabric
  channel-group $srcchannelgroup 
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.c2.vpcpomemberfex.tmp.txt 
fi

if [ "$n5k" == "TRUE" ]  && [ "$fexpo" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description $dstsys $dstmemberint 
  switchport mode fex-fabric
  vpc $vpcid
  fex associate $vpcid
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b2.fexpo.tmp.txt 
fi 

if [ "$n5k" == "TRUE" ]  && [ "$fexpo" == "TRUE" ]
then
  echo "
  fex $vpcid
  description $dstsys
  " >> ./config-elements/$srcsys.vdc$vdcid.a9.fex-description.tmp.txt 
fi 


#option for creating n7k peer keep-alives
if [ "$peerkeepalivelink" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description keepalive interface $dstsys $dstmemberint 
  logging event port link-status
  vrf member peerkeepalive
  ip address $srcipaddress$subnetmask
  mtu $mtu  
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b3.peerkeepalivelink.tmp.txt 
fi   
 
if [ "$peerkeepalivelinkmember" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description keepalive member interface $dstsys $dstmemberint 
  mtu $mtu
  logging event port link-status
  udld aggressive
  channel-group $srcchannelgroup mode active
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.c3.peerkeepalivelinkmember.tmp.txt 
fi    

## option for creating n5k peer keep-alives
if [ "$peerkeepalivelink" == "TRUE" ]  && [ "$n5k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description keepalive interface $dstsys $dstmemberint 
  ip address $srcipaddress$subnetmask 
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b3.peerkeepalivelink.tmp.txt 
fi   
 
if [ "$peerkeepalivelinkmember" == "TRUE" ]  && [ "$n5k" == "TRUE" ]
then
  echo "
  interface $srcmemberint
  description keepalive member interface $dstsys $dstmemberint 
  switchport access vlan $vlanid
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.c3.peerkeepalivelinkmember.tmp.txt 
fi    



if [ "$loopback" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  #create the loopack interface first
  echo "
  interface $srcmemberint
  ip address $srcipaddress$subnetmask  
  description loopback interface for $srcsys
  ip router ospf 1 area $ospfarea
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b4.loopback.tmp.txt 
  
  #create the ospf statements while we are here
fi

if [ "$loopback" == "TRUE" ]  && [ "$n7k" == "TRUE" ]  
then
  echo "
  route-map static-2-ospf permit 10
  router ospf 1
  router-id $srcipaddress
  redistribute static route-map static-2-ospf
  log-adjacency-changes
  auto-cost reference-bandwidth 100000 " >> ./config-elements/$srcsys.vdc$vdcid.z1.ospf.tmp.txt 
  
fi    

if [ "$mgmt" == "TRUE" ]
then
  #create the mgmt interface description
  echo "
  interface $srcmemberint
  ip address $srcipaddress$subnetmask
  description management interface for $srcsys
  no shutdown" >> ./config-elements/$srcsys.vdc$vdcid.b5.mgmt.tmp.txt 
  
  #give the mgmt interface a default route
  echo "
  vrf context management
  ip route 0.0.0.0/0 $defaultgw " >> ./config-elements/$srcsys.vdc$vdcid.b6.mgmt-gw.tmp.txt
  
fi    

# create vpc configurations for n7k
if [ "$vpca" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  #create create the VPC primary configuration
  echo "
  feature vpc
  vrf context peerkeepalive
  spanning-tree mode rapid-pvst
  spanning-tree vlan 1-3967,4048-4093 priority 0
  udld aggressive
  
  vpc domain 1
  role priority 3000
  peer-keepalive destination 169.254.1.2 source 169.254.1.1 vrf peerkeepalive
  peer-gateway  " >> ./config-elements/$srcsys.vdc$vdcid.a2.vpc.tmp.txt 
  
fi  

if [ "$vpcb" == "TRUE" ]  && [ "$n7k" == "TRUE" ]
then
  #create create the VPC secondary configuration
  echo "
  feature vpc
  vrf context peerkeepalive
  spanning-tree mode rapid-pvst
  spanning-tree vlan 1-3967,4048-4093 priority 4096

  
  vpc domain 1
  role priority 6000
  peer-keepalive destination 169.254.1.1 source 169.254.1.2 vrf peerkeepalive
  peer-gateway" >> ./config-elements/$srcsys.vdc$vdcid.a3.vpc.tmp.txt 
  
fi  

# create vpc configurations for n5k
if [ "$vpca" == "TRUE" ]  && [ "$n5k" == "TRUE" ]
then
  #create create the VPC primary configuration
  echo "
  feature vpc
  spanning-tree mode rapid-pvst
  spanning-tree vlan 1-3967,4048-4093 priority 0
  vlan 2
  name peerkeepalive

  
  vpc domain 2
  role priority 3000
  peer-keepalive destination 169.254.1.2 source 169.254.1.1 vrf default
  " >> ./config-elements/$srcsys.vdc$vdcid.c1.vpc.tmp.txt 
  
fi  

if [ "$vpcb" == "TRUE" ]  && [ "$n5k" == "TRUE" ]
then
  #create create the VPC secondary configuration
  echo "
  feature vpc
  spanning-tree mode rapid-pvst
  spanning-tree vlan 1-3967,4048-4093 priority 4096 
  vlan 2
  name peerkeepalive
  
  vpc domain 2
  role priority 6000
  peer-keepalive destination 169.254.1.1 source 169.254.1.2 vrf default
  " >> ./config-elements/$srcsys.vdc$vdcid.c1.vpc.tmp.txt 
  
fi
## note HSRP part of the code is unfinished ##
if [ "$hsrpa" == "TRUE" ]
then
  #create create the primary hsrp configuration
  echo "
  vlan $vlanid
  name vlan $vlanid" >> ./config-elements/$srcsys.vdc$vdcid.a4.vlana.tmp.txt
  
  echo "
  interface $srcmemberint
  no shutdown
  mtu $mtu
  no ip redirects
  ip address $srcipaddress$subnetmask
  hsrp version 2
  hsrp $vlanid
  preempt
  priority 110
  ip 10.1.$vlanid.1
  no shutdown
  " >> ./config-elements/$srcsys.vdc$vdcid.a4.hsrpa.tmp.txt 
  
fi  
## note HSRP part of the code is unfinished ##
if [ "$hsrpb" == "TRUE" ]
then
  #create create the primary hsrp configuration
  echo "
  vlan $vlanid
  name vlan $vlanid" >> ./config-elements/$srcsys.vdc$vdcid.a4.vlanb.tmp.txt
  
  echo "
  interface $srcmemberint
  no shutdown
  mtu $mtu
  no ip redirects
  ip address $srcipaddress$subnetmask
  hsrp version 2
  hsrp $vlanid
  ip 10.1.$vlanid.1
  no shutdown
  " >> ./config-elements/$srcsys.vdc$vdcid.a4.hsrpb.tmp.txt 
  
fi 

if [ "$mgmt" == "TRUE" ] && [ "$tacacs" == "TRUE" ]
then
  #create create the tacacs configurtion
echo "

feature tacacs+

tacacs-server host 1.1.1.1 key secret timeout 10
tacacs-server host 1.1.1.2 key secret timeout 10
tacacs-server host 1.1.1.3 key secret timeout 10
tacacs-server host 1.1.1.4 key secret timeout 10



aaa group server tacacs+ AAA_SERVERS 
    server 1.1.1.1
    server 1.1.1.2
    server 1.1.1.3
    server 1.1.1.4
    use-vrf management
    source-interface mgmt0

aaa authentication login default group AAA_SERVERS
aaa authentication login console group AAA_SERVERS
aaa authentication login console fallback error local 
 
banner motd ^


 Access to this system is limited to authorized users for company 
 business purposes only.    
 ^C                                      
                                                          
" >> ./config-elements/$srcsys.vdc$vdcid.z2.tacacs.tmp.txt
  
fi 

if [ "$mgmt" == "TRUE" ] 
then

echo "
$srcipaddress	$srcsys.vdc$vdcid " >> tmp/hosts.skynet.tmp.txt

fi

#create a temporary file with a list of hostnames in the file (I should probably do this in memory in the future, and dedup on entry)
echo "$srcsys" >> tmp/srcsys.tmp.txt

#end the while loop reading in file
done < interface-assignments.csv 

echo " "
echo " deduplicating source system list"

#deduplicate the host list
awk '!($0 in a) {a[$0];print}' < tmp/srcsys.tmp.txt > tmp/srcsys.deduped1.tmp.txt

#remove blank lines
sed '/^$/d' tmp/srcsys.deduped1.tmp.txt > tmp/srcsys.deduped2.tmp.txt

#remove Source system from the host name file
sed '/Source system/d' tmp/srcsys.deduped2.tmp.txt > tmp/srcsys.deduped.tmp.txt

# combine all the config elements into master configs
echo " " 
echo " concatenating config elements into master configs "

while read srcsys
do
  echo "******************************************"
  echo "creating configuration  -> [${srcsys}]"
cat ./config-elements/$srcsys* > ./config-output/$srcsys.config.txt

done < tmp/srcsys.deduped.tmp.txt
