#!/bin/bash
echo "What you want do to ? "
echo "================================================================================================================="
echo "1. Connect via SSH [DEFAULT]"
echo "2. Nothing"
echo -e "================================================================================================================= \n"
if [[ $WSLENV == *"VSCODE_WSL_EXT_LOCATION"* ]]; then #default
	   reset
	   exit
fi	
read -p "Choice : " Choice
hex=$(echo "$Choice" |xxd -p)
	
if [ "$hex" == '0a' ] || [ "$Choice" == "1" ]; then #default
	    ssh root@172.16.0.100
fi
if [ "$Choice" == "Nothing" ] || [ "$Choice" == "2" ]; then 
     	exit
fi
