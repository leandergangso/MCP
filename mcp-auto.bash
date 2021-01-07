#!/bin/bash

# will automaticly activate and deactivate virtual environments.
cd() {
	# run main cd command
	builtin cd "$@"

	# check for "ls"
	if [[ "$automatic_ls" == true ]]; then
		filecount=$(ls | wc -l)
		if  [[ "$filecount" -le "$ls_file_limit" ]]; then
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
	if [[ $1 ]]; then
		re='^[0-9]+$'
		if [[ $1 =~ $re ]]; then
			# set new limit nr
			sed -i '103 s/ls_file_limit=".*"/ls_file_limit="'$1'"/' "$MCP_DIR/mcp-auto.bash"
			ls_file_limit=$1
			echo 'ls limit updated to:' $ls_file_limit
		else
			echo 'not valid, need a number'
		fi
	else
		# toggle value
		if [[ "$automatic_ls" == true ]]; then
			automatic_ls=false
			echo 'autols is disabled'
		else
			automatic_ls=true
			echo 'autols is enabled (disabled when more than '$ls_file_limit' itmes in dir)'
		fi
		# edit file
		sed -i '$ s/automatic_ls=.*/automatic_ls='$automatic_ls'/' "$MCP_DIR/mcp-auto.bash"
	fi
}

# file dir path
MCP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# disable on dir file count
ls_file_limit="20"
# toggle automatic ls
automatic_ls=true
