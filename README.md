# #1: SuperMassive Multiplicator

Is a bash script that using govc deploys the OVA file of the FortiSIEM Super to a VCenter environment, but then takes care of the basic configurations: setup timezone, configure IP and finish the installation until the part when you need to provide the license file (I may try to automate that part too).

**Important: This script doesn't have validation routines for the input values used, so be careful with the information provided.**

Requirements: 
- Linux distro (I tested on Ubuntu)
- govc binary installed
- jq (apt install jq)

Usage:
First, edit the script and replace the values of the following variables to fit your VCenter setup:

```
export GOVC_URL=https://vcsa.fortilabs.org/sdk
export GOVC_USERNAME=administrator@aiur.fortilabs.org
export GOVC_PASSWORD=th3p4ssw0rd
export GOVC_DATASTORE=vsanDatastore
export GOVC_NETWORK=dc_mgmt
export GOVC_DATACENTER=Aiur

ovalocation="https://vcsa.fortilabs.org/folder/a78b945b-dca1-cab1-64a6-ac1f6b1a7eda/FortiSIEM-VA-5.1.0.1336.ova?dcPath=Aiur&dsName=vsanDatastore"

```

For use as location an URL of the OVA file from the ESX/VCenter datastore, first upload the OVA file to the datastore, then browse it from something like this: https://ESX-OR-VCENTER/folder, after finding the file just copy the URL and use it here, another option is to save the file in any other web server or provide the local path from the same machine that you are using for executing this script.

Usage: 

sh supermassive.sh VM_Name IP NETMASK GW DNS VM_PORTGROUP

Example:

sh supermassive.sh fsm51-super001 10.10.10.101 255.255.255.0 10.10.10.1 10.10.10.1 dc_mgmt

Sample Output:

```

root@devops-sandbox:~/fortilabs_devops/fsm# sh supermassive.sh fsm51-super001 10.10.10.101 255.255.255.0 10.10.10.1 10.10.10.1 dc_mgmt
 
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
[10-09-18 02:55:05] Injecting OVF environment...
Powering on VirtualMachine:vm-216... OK
Uploading unattended script ...
Script ready, Go!! Time to do some magic... 
Gathering Logs...
[10-09-18 03:13:54] Downloading... OK
govc: file already exists
Final reboot...

The End...: 2018-09-10-03:14:09
--------------------------
FSM Deployed:
--------------------------
VM/Host Name: fsm51-super001
Super URL: https://10.10.10.101/
UUID: 42398B99-DAA1-148A-A9EE-8B75676C358D

```
Next version will allow the creation of a set of Super VMs to deploy, especially for setup a training environment, in the meantime, you could use the following command:

```
#!/bin/bash
for super in {101..110}
do
    sh supermassive.sh fsm51-pod-$super 10.10.10.$super 255.255.255.0 10.10.10.1 10.10.10.1 dc_mgmt
done
```



# # 2: FSM License Upload Tool v1.0

Is simple curl script for upload license to FSM

Usage:  sh fsmuploadlic.sh IP LIC_FILE
Example: sh fsmuploadlic.sh 10.10.10.101 FSMS010000003166.lic
