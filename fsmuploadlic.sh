#!/bin/bash
echo ""
echo "----------------------------------"
echo " - FSM License Upload Tool v1.0 - "
echo "----------------------------------"
echo " - Info: simple curl script for upload license to FSM"
echo " - Usage:  sh fsmuploadlic.sh IP LIC_FILE - "
echo " - Example: sh fsmuploadlic.sh 10.10.10.101 FSMS010000003166.lic - "

curl -s -L -k -F "modeBox=va"  -F "username=admin" -F "password=admin*1" -F "uploadFile=@$2" -F "filePathInput=$2" https://$1/phoenix/uploadLicense|grep formTitle | sed -e 's/<div id="formTitle">//g' |cut -d . -f 1 |sed -e 's/                        //g'
