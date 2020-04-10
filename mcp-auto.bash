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
		[[ $@ == *'..'* ]] && return
		# when im not in project folder
		[[ $PWD != *'MyProjects/'* ]] && return
		
		# set current path
		local folder="$PWD"
		# split input
		local input
		IFS='/' read -ra input <<< "$@"

		# backtrack to find existing .env folder
		for i in ${input[@]}; do
			## activate when going INTO a folder with venv
			if [[ -d "$folder/.env/" ]] ; then
				# autoenv enabled?
				[[ -a "$folder/.env/Scripts/autoenv" ]] &&
				source "$folder/.env/Scripts/activate" &&
				autoenv_path="$folder"
				# quit
				break
			else
				# backtrack - remove last /*
				local folder="$(echo "$folder" | sed 's|\(.*\)/.*|\1|')"
			fi
		done
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
				source "$folder/.env/Scripts/activate" &&
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