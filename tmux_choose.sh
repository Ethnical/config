#!/bin/bash 
ARRAY=()
RES=0
p=""

if [[ -z "${TMUX}" ]]; then  #Detect if $TMUX is set.
	while [[ -z "$name" ]]
	do
        echo "SESSIONS AVALAIBLE :"
		echo "================================================================================================================="
		tmux ls
		echo "new: Create a new session."
		echo "No: Not using TMUX"
		echo -e "================================================================================================================= \n"
		arr=$(tmux ls |awk '{print $1}' | cut -d ":" -f1)
		while read p; do
  			ARRAY+=($p)	
		done <<< "$arr"
		echo "Which session do we need ?"
		read -p "Session Name : " name
		echo $(date) $name >> /var/log/tmux_choose.log
		echo ""
		hex=$(echo "$name" |xxd -p) 
		if [[ $name == *"echo"* ]]; then #RemoteSSH_tricks
                  exit
                fi
		if [[ $name == "new" ]]; then #Create Session
			read -p "Name for the session? : " session
			tmux new -s $session
			exit
		fi
		if [[ "$hex" == '0a' ]]; then #RemoteSSH_tricks
            exit
        fi
		if [[ $name == "No" ]]; then
			exit
		fi
		if [[ " ${ARRAY[*]} " == *$name* ]]; then
			tmux attach -t $name
		else
			if [[ $name == *"video"* ]]; then #VideoSession
			    tmux new -s $name -dP
				tmux set-environment -t $name HOME /home/rootube
				tmux send-keys -t $name:0 "export HOME=/home/rootube;reset;neofetch" C-m #R
				tmux attach -t $name
				exit
			fi
			tput clear
			tput setaf 3 
			echo "Retry with the following sessions :"
			tput clear
			name=""
		
		fi
	done	
	
fi

