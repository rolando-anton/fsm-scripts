# fsm-scripts
FortiSIEM scripts, sharing to not forget :)

# #1: SuperMassive Multiplicator

Is a bash script that using govc deploys the OVA file of the FortiSIEM Super to a VCenter environment, but then takes care of the basic configurations: setup timezone, configure IP and finish the installation until the part when you need to provide the license file (I may try to automate that part too).

Requeriments: 
- Linux distro (I tested on Ubuntu)
- govc binary installed
- jq (apt install jq)

Usage:
First edit the script and replace the values of the following varialbes acordly to your VCenter setup:

`export GOVC_URL=https://vcsa.fortilabs.org/sdk`

`export GOVC_USERNAME=administrator@aiur.fortilabs.org`

`export GOVC_PASSWORD=th3p4ssw0rd`

`export GOVC_DATASTORE=vsanDatastore`

`export GOVC_NETWORK=dc_mgmt`

`export GOVC_DATACENTER=Aiur`

Usage: sh supermassive.sh VM_Name IP NETMASK GW DNS VM_PORTGROUP

Example:

Example: sh supermassive.sh fsm51-super001 10.10.10.101 255.255.255.0 10.10.10.1 10.10.10.1 dc_mgmt

Sample Output:

root@ansible:~/fortilabs_devops/fsm# sh supermassive.sh fsm51-super001 10.10.10.101 255.255.255.0 10.10.10.1 10.10.10.1 dc_mgmt
 
(c) 2018 Fortinet LATAM CSE - FortiSIEM SuperMassive Multiplicator - 1.0


 ███████╗██╗   ██╗██████╗ ███████╗██████╗ ███╗   ███╗ █████╗ ███████╗███████╗██╗██╗   ██╗███████╗  
 ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔════╝██╔════╝██║██║   ██║██╔════╝  
 ███████╗██║   ██║██████╔╝█████╗  ██████╔╝██╔████╔██║███████║███████╗███████╗██║██║   ██║█████╗    
 ╚════██║██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══██║╚════██║╚════██║██║╚██╗ ██╔╝██╔══╝    
 ███████║╚██████╔╝██║     ███████╗██║  ██║██║ ╚═╝ ██║██║  ██║███████║███████║██║ ╚████╔╝ ███████╗  
 ╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝  ╚══════╝  

 ███╗   ███╗██╗   ██╗██╗  ████████╗██╗██████╗ ██╗     ██╗ ██████╗ █████╗ ████████╗ ██████╗ ██████╗     
 ████╗ ████║██║   ██║██║  ╚══██╔══╝██║██╔══██╗██║     ██║██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗    
 ██╔████╔██║██║   ██║██║     ██║   ██║██████╔╝██║     ██║██║     ███████║   ██║   ██║   ██║██████╔╝    
 ██║╚██╔╝██║██║   ██║██║     ██║   ██║██╔═══╝ ██║     ██║██║     ██╔══██║   ██║   ██║   ██║██╔══██╗    
 ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║██║     ███████╗██║╚██████╗██║  ██║   ██║   ╚██████╔╝██║  ██║    
 ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝    




Usage: sh supermassive.sh VM_Name IP NETMASK GW DNS VM_PORTGROUP
Example: sh supermassive.sh fsm51-super001 10.10.10.101 255.255.255.0 10.10.10.1 10.10.10.1 dc_mgmt

Uno, dos, tres, catorce!: 2018-09-10-02:50:50
Creating Template Definition ...
Deploying OVA ...
[10-09-18 02:53:25] Uploading system.vmdk... OK
[10-09-18 02:54:14] Uploading cmdb.vmdk... OK
