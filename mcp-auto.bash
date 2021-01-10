#!/bin/bash

# will automaticly activate and deactivate virtual environments.
cd() {
	# run main cd command
	builtin cd "$@"

	# check for "ls"
	if [[ "$MCP_AUTO_LS" == true ]]; then
		filecount=$(ls | wc -l)
		if  [[ "$filecount" -le "$MCP_LS_LIMIT" ]]; then
			ls
		fi
	fi

	# deactivate when going to a higher lvl than the env folder
	if [[ "$PWD" != *"$autoenv_path"* ]] ; then
		deactivate
		unset autoenv_path
	fi
	
	# if virtual_env string length is zero (not activated)
	if [[ -z "$VIRTUAL_ENV" ]]; then
		# if no arguments are given
		[[ $@ == '' ]] && return
		# if im going back
		[[ $@ == '..' ]] && return
		
		## activate when going INTO a folder with venv
		if [[ -a "$PWD/.env/Scripts/autoenv" ]]; then
			source "$PWD/.env/Scripts/activate"
			autoenv_path="$PWD"

		else if [[ -a '.env/bin/autoenv' ]]; then
			source "$PWD/.env/bin/activate"
			autoenv_path="$PWD"
		fi
		fi		
	fi
}

# will activate .env if found
activate(){
	# virtual env is not active 
	if [[ -z "$VIRTUAL_ENV" ]]; then
		# set current path
		local folder="$PWD"

		# backtrack to find existing .env folder
		for i in {1..10}; do
			# activate when going INTO a folder with venv
			if [[ -d "$folder/.env/" ]] ; then
				if [[ -d "$folder/.env/Scripts" ]]; then
					source "$folder/.env/Scripts/activate"
				else
					source "$folder/.env/bin/activate"
				fi
				autoenv_path="$folder"
				# quit
				return
			else
				# backtrack - remove last /*
				local folder="$(echo "$folder" | sed 's|\(.*\)/.*|\1|')"
			fi
		done
		# user error
		echo 'error, no environment found.'
	else
		# user error
		echo 'error, env is already active.'
	fi
}

# will run "ls" command after every "cd" command
autols(){
	if [[ ! -f "$MCP_PATH/default_values" ]]; then
		echo "First time setup..."
		echo "This file is used to keep track of you settings:" > "$MCP_PATH/default_values"
		echo "MCP_AUTO_LS=false" >> "$MCP_PATH/default_values"
		echo "MCP_LS_LIMIT=20" >> "$MCP_PATH/default_values"
		MCP_AUTO_LS=false
		MCP_LS_LIMIT=20
	else
		MCP_AUTO_LS=$(grep "MCP_AUTO_LS=.*" "$MCP_PATH/default_values" | cut -d '=' -f2)
		MCP_LS_LIMIT=$(grep "MCP_LS_LIMIT=.*" "$MCP_PATH/default_values" | cut -d '=' -f2)
	fi

	if [[ $1 ]]; then
		re='^[0-9]+$'
		if [[ $1 =~ $re ]]; then
			# set new limit nr
			sed -i "s/MCP_LS_LIMIT=.*/MCP_LS_LIMIT=$1/" "$MCP_PATH/default_values"
			MCP_LS_LIMIT=$1
			echo 'limit updated to:' $MCP_LS_LIMIT
		else
			echo 'not valid, need a number'
		fi
	else
		# toggle value
		if [[ "$MCP_AUTO_LS" == false ]]; then
			MCP_AUTO_LS=true
			echo "autols is enabled (disabled when more than $MCP_LS_LIMIT itmes in dir)"
		else
			MCP_AUTO_LS=false
			echo 'autols is disabled'
		fi
		# edit file
		sed -i "s/MCP_AUTO_LS=.*/MCP_AUTO_LS=$MCP_AUTO_LS/" "$MCP_PATH/default_values"
	fi
}

# file dir path
MCP_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

