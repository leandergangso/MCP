#!/bin/bash


# this script will try to setup MCP on the users computer with
# as little humen intervention as possible.


# init variables
MCP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
red=$'\e[1;31m'
end=$'\e[0m'


# confirm
read -p 'Setting up MCP on your system, continue? [y,n] ' yn
case $yn in
    [Yy] ) ;;
    * ) printf 'Setup has been canceled.\n' && exit 0;;
esac


# add username
while true; do
    read -p "Enter your GITHUB username: " USERNAME
    read -p "Is this your username, \"$USERNAME\" [y,n] " yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) ;;
        * ) printf "Invalid input, try again.\n";;
    esac
done


# check for existing PAT
while true; do
    read -p "Do you have a Personal Access Token (PAT)? [y,n] " yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) printf "Create PAT here:$red https://github.com/settings/tokens $end\nNote: the PAT needs to have $red'REPO'$end and $red'DELETE_REPO'$end tagged.\n" && break;;
        * ) printf "Invalid input, try again.\n";;
    esac
done


# ask for PAT
while true; do
    read -p "Enter you PAT: " PAT
    read -p "Is this your PAT, \"$PAT\" [y,n] " yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) ;;
        * ) printf "Invalid input, try again.\n";;
    esac
done


# locate .profile or .bashrc
if [[ -f ~/.profile ]]; then
    FILE=~/.profile
else
    if [[ -f ~/.bashrc ]]; then
        FILE=~/.bashrc
    else
        read -p "Enter full path to .profile or .bashrc: " FILE
    fi
fi


# add path to file
if ! grep -q "export PATH=.*$MCP_DIR" "$FILE"; then
    printf "export PATH=\"\$PATH:$MCP_DIR\"\n" >> "$FILE"
    printf "PATH added to "$FILE".\n"
fi


# add github auth to FILE
if ! grep -q "export GITHUB_USERNAME" "$FILE"; then
    printf "export GITHUB_USERNAME=\"$USERNAME\"\n" >> "$FILE"
    printf "GITHUB_USERNAME added to "$FILE".\n"
fi
if ! grep -q "export GITHUB_AUTH" "$FILE"; then
    printf "export GITHUB_AUTH=\"$PAT\"\n" >> "$FILE"
    printf "GITHUB_AUTH added to "$FILE".\n"
fi


# add mcp-auto.bash to FILE
if ! grep -q "mcp-auto.bash" "$FILE"; then
    printf "source mcp-auto.bash\n" >> "$FILE"
    printf "mcp-auto.bash added to "$FILE".\n"
fi


# check if python3 and pip3 is installed
type -P python3 >/dev/null 2>&1 || printf "$red!! You need to install python3: sudo apt install python3 !!$end\n"
python3 -m venv >/dev/null 2>&1 || if [[ $? != 2 ]]; then printf "$red!! You need to install python3-venv: sudo apt install python3-venv !!$end\n" fi
type -P pip3 >/dev/null 2>&1 || printf "$red!! You need to install pip3: sudo apt install python3-pip !!$end\n"
type -P pip3 >/dev/null 2>&1 && pip3 list | grep requests >/dev/null 2>&1 || printf "$red!! You need to install requests: pip3 install requests !!$end\n"


# finish text + tips
printf "\nSetup finished.\n\nPlease fix any errors(in$red red$end) that may have occured!\n"

exit 0
