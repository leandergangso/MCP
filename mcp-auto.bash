#!/usr/bin/bash

# will automaticly activate and deactivate virtual environments.
cd() {
	# run main cd command
	builtin cd "$@"
	
	# if virtual_env string length is zero 
	if [[ -z "$VIRTUAL_ENV" ]]; then
		# if no arguments are given
		[[ $@ == '' ]] && return
		# if im going back
		[[ $@ == '..' ]] && return
		
		## activate when going INTO a folder with venv
		if [[ -d "$PWD/.env/Scripts" ]]; then
			source "$PWD/.env/Scripts/activate"
			autoenv_path="$PWD"
		else
		if [[ -d '.env/bin' ]]; then
			source "$PWD/.env/bin/activate"
			autoenv_path="$PWD"
		fi
		fi
	else
		## deactivate when going to a higher lvl than the env folder
		if [[ "$PWD" != *"$autoenv_path"* ]] ; then
			# echo 'deactivate'
			deactivate
			unset autoenv_path
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
			## activate when going INTO a folder with venv
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