#!/bin/bash 
ARRAY=("New" "Nothing")
Counter=1
p=""
if [[ $TERM_PROGRAM == *"vscode"* ]]; then #default
	   reset
	   exit
fi	
if [[ -z "${TMUX}" ]]; then  #Detect if $TMUX is set.
	while [[ -z "$number" ]]
	do
        #echo "SESSIONS AVALAIBLE :"
		
		#echo "================================================================================================================="
		#tmux ls
		#echo "new: Create a new session."
		#echo "No: Not using TMUX"
		echo -e "================================================================================================================="
		arr=$(tmux ls |awk '{print $1}' | cut -d ":" -f1)
		while read p; do
  			ARRAY+=($p)	
		done <<< "$arr"
		for i in "${ARRAY[@]}"
		do
			echo $Counter. $i
			Counter=$((Counter+1))
		done
        echo "================================================================================================================="
		echo "Which session do we need ?"
		read -p "Session Numbers : " number
		number=$((number-1)) #DOIT CHECK SI c'est bien un int
		#echo $(date) $number >> /var/log/tmux_choose.log #LOGGING CMDLINE
		hex=$(echo "$number" |xxd -p) 
		#if [[ "${ARRAY["$number"]}" == *"echo"* ]]; then #RemoteSSH_tricks
        #          exit
        #        fi
		echo ${ARRAY["$number"]}
		if [[ "${ARRAY["$number"]}" == "New" ]]; then #Create Session
			read -p "Name for the NEW session? : " session
			tmux new -s $session -dP
			echo "$session"
		    if [ "$session" == "video" ]; then
				tmux set-environment -t $session HOME /home/rootube
			    tmux split-window "fish"

				tmux send-keys -t $session "export HOME=/home/rootube;reset;neofetch" C-m
				tmux select-pane -t 0
				tmux kill-pan
				
				tmux attach -t $session
				tmux split-window "shell command"
				exit
			fi
			tmux attach -t $session
			exit
		fi
		if [[ "$hex" == '0a' ]]; then #RemoteSSH_tricks
            exit
        fi
		if [[ ${ARRAY["$number"]} == "Nothing" ]]; then
			exit
		fi

		
	
		if [ "${ARRAY["$number"]}" == "video" ]; then #VideoSession
			name=${ARRAY["$number"]}
			res=$(tmux new -s "$name" -dP 2>&1) #Check if duplicate or not
			if [[ "$res" == *"duplicate"* ]]; then
				echo "DUPLICATE"
				tmux attach -t $name
				exit
			fi
		fi	
		
		if [[ "${ARRAY[*]}" =~ "${ARRAY["$number"]}" ]]; then #RemoteSSH_tricks
            tmux attach -t ${ARRAY["$number"]}
			exit
        fi

		tput clear
		number=""
	
	
	ARRAY=("New" "Nothing")
	Counter=1
	done	
	
fi

