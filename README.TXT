NAME
	Cisco Nexus Configurator

SYNOPSIS
	./nexus-configurator.sh
	
DESCRIPTION
	The Cisco Nexus Configurator was created to deploy nexus 7k 5k and 2k configurations for large scale data centers. 
	It ensures consistency of deployment across thousands of network elements with the goal of minimizing input errors
	while decreasing the time to deployment.

	The Cisco Nexus Configurator reads from the CSV file interface-assignments.csv . Each line contains interface elements
	and values that are matched by the configurator script and used to generate output configurations.

	Network device configuration files are outputed to the config-output directory.

	Partial configs (for example, the vpc port channel interfaces and portchannel members) are outputed to config-elements.
	This is handy if you need to update one portion of a config. You can grab from config-elements instead of the complete files. 
		 

SEE ALSO
	cat bash sed awk

HISTORY
	This is an evolution of ./vrf-gen.sh (written by Colin McNamara) tool for generating casino service provider topologies. 
 

AUTHORS
     	Colin McNamara <colin@2cups.com> http://www.colinmcnamara.com
