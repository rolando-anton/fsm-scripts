#!/bin/bash

# FortiSIEM SuperMassive Multiplicator
# ranton@fortinet.com
# Version 1.0 - Sep 2018
# This script doesn't have validation routines for the input values used, so be careful with the information provided.

# Edit the following variables as required:

export GOVC_INSECURE=1
export GOVC_URL=https://vcsa.fortilabs.org/sdk
export GOVC_USERNAME=administrator@aiur.fortilabs.org
export GOVC_PASSWORD=sup3rp4ssw0rd
export GOVC_DATASTORE=vsanDatastore
export GOVC_NETWORK=dc_mgmt
export GOVC_DATACENTER=Aiur

# This could be an URL or a local file

ovalocation="https://vcsa.fortilabs.org/folder/a78b945b-dca1-cab1-64a6-ac1f6b1a7eda/FortiSIEM-VA-5.1.0.1336.ova?dcPath=Aiur&dsName=vsanDatastore"

# DO NOT EDIT FROM THIS POINT

red='\e[1;31m'

echo $red "\n(c) 2018 Fortinet LATAM CSE - FortiSIEM SuperMassive Multiplicator - 1.0\n"
echo ""
echo $red "███████╗██╗   ██╗██████╗ ███████╗██████╗ ███╗   ███╗ █████╗ ███████╗███████╗██╗██╗   ██╗███████╗  "
echo $red "██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔════╝██╔════╝██║██║   ██║██╔════╝  "
echo $red "███████╗██║   ██║██████╔╝█████╗  ██████╔╝██╔████╔██║███████║███████╗███████╗██║██║   ██║█████╗    "
echo $red "╚════██║██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══██║╚════██║╚════██║██║╚██╗ ██╔╝██╔══╝    "
echo $red "███████║╚██████╔╝██║     ███████╗██║  ██║██║ ╚═╝ ██║██║  ██║███████║███████║██║ ╚████╔╝ ███████╗  "
echo $red "╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝  ╚══════╝  "
echo ""                                                                                                  
echo $red "███╗   ███╗██╗   ██╗██╗  ████████╗██╗██████╗ ██╗     ██╗ ██████╗ █████╗ ████████╗ ██████╗ ██████╗     "
echo $red "████╗ ████║██║   ██║██║  ╚══██╔══╝██║██╔══██╗██║     ██║██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗    "
echo $red "██╔████╔██║██║   ██║██║     ██║   ██║██████╔╝██║     ██║██║     ███████║   ██║   ██║   ██║██████╔╝    "
echo $red "██║╚██╔╝██║██║   ██║██║     ██║   ██║██╔═══╝ ██║     ██║██║     ██╔══██║   ██║   ██║   ██║██╔══██╗    "
echo $red "██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║██║     ███████╗██║╚██████╗██║  ██║   ██║   ╚██████╔╝██║  ██║    "
echo $red "╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝    "
echo "\n"
echo "\n"
echo "Usage: sh supermassive.sh VM_Name IP NETMASK GW DNS VM_PORTGROUP"
echo "Example: sh supermassive.sh fsm51-super001 10.10.10.101 255.255.255.0 10.10.10.1 10.10.10.1 dc_mgmt"
echo "\033[m"

echo "Uno, dos, tres, catorce!: $(date +%Y-%m-%d-%H:%M:%S)"
echo "Creating Template Definition ..."
sed "s/fsm-name/$1/g" fsm_template.json > $1.json
sed -i "s/fsm-ip/$2/g" $1.json
sed -i "s/vm_portgroup/$6/g" $1.json
echo "Deploying OVA ..."
govc import.ova -options=$1.json "$ovalocation"
govc vm.change -vm $1 -m=24576
govc vm.power -on $1
govc vm.ip $1 1>/dev/null
sleep 60
rm -f $1.json
export GOVC_VM=$1
export GOVC_GUEST_LOGIN=root:ProspectHills
echo "Uploading unattended script ..."
script=$(govc guest.mktemp)
govc guest.upload -f - "$script" << EOF
#!/bin/bash
echo "Configuring Time Zone"
export LC_CTYPE="en_US.utf8"
/opt/vmware/share/vami/vami_set_timezone_cmd America/Lima
echo "$2 		$1	$1" >> /etc/hosts
/opt/vmware/share/vami/vami_set_network eth0 STATICV4 $2 $3 $4
/opt/vmware/share/vami/vami_set_dns $5
sed -i '/reboot/d' /opt/phoenix/deployment/jumpbox/phinitsuper
/opt/phoenix/deployment/jumpbox/phinitsuper 2>>/opt/phoenix/log/phinitsuper_$(date +%Y%m%d).log
echo reboot >> /opt/phoenix/deployment/jumpbox/phinitsuper
echo "Done"
EOF

govc guest.chmod 0755 "$script"
echo "Script ready, Go!! Time to do some magic... "
pid=$(govc guest.start "$script" '>&' /root/fsmdeploy.log)
status=$(govc guest.ps -p "$pid" -json -X | jq .ProcessInfo[].ExitCode)
if [ "$status" -ne "0" ] ; then
	echo "Tadam!"
  exit 1
fi
echo "Gathering Logs..."
govc guest.download -vm=$1 /root/fsmdeploy.log fsmdeploy-$1.log
govc guest.download -vm=$1 /opt/phoenix/log/phinitsuper_$(date +%Y%m%d).log phinitsuper_$(date +%Y%m%d).log
echo "Final reboot..."
govc guest.run /sbin/reboot 2> /dev/null
sleep 15
uuid=$(grep "System hardware id" fsmdeploy-$1.log|awk -F \: {'print $2'} | sed -e 's/ //g')
govc vm.ip $1 1>/dev/null
echo "The End...: $(date +%Y-%m-%d-%H:%M:%S)"
echo "--------------------------"
echo "FSM Deployed:"
echo "--------------------------"
echo "VM/Host Name: $1"
echo "Super URL: https://$2/"
echo "UUID: $uuid"
echo "--------------------------"
