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
    read -p "Is this your username, "$USERNAME" [y,n] " yn
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
    read -p "Is this your PAT, "$PAT" [y,n] " yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) ;;
        * ) printf "Invalid input, try again.\n";;
    esac
done


# locate .profile or .bashrc
if [[ -f ~/.profile ]]; then
    FILE="~/.profile"
else
    if [[ -f ~/.bashrc ]]; then
        FILE="~/.bashrc"
    else
        read -p "Enter full path to .profile or .bashrc: " FILE
    fi
fi


# add path to file
if ! grep -q "export PATH=$PATH:$MCP_DIR" $FILE; then
    printf "export PATH=$PATH:$MCP_DIR" >> $FILE
fi


# add github auth to FILE
if ! grep -q "export GITHUB_USERNAME" $FILE; then
    printf "export GITHUB_USERNAME=\"$USERNAME\"\n" >> $FILE
fi
if ! grep -q "export GITHUB_AUTH" $FILE; then
    printf "export GITHUB_AUTH=\"$PAT\"\n" >> $FILE
fi
printf "GITHUB variables added to $FILE.\n"


# add mcp-auto.bash to FILE
if ! grep -q "mcp-auto.bash" $FILE; then
    printf "source mcp-auto.bash\n" >> $FILE
    printf "mcp-auto.bash added to $FILE.\n"
fi


# check if python3 and pip3 is installed
type -P python3 >/dev/null 2>&1 && printf "Python3 is installed.\n" || printf "$red!! You need to install python3. !!$end\n"
type -P pip3 >/dev/null 2>&1 && printf "Pip3 is installed.\n" || printf "$red!! You need to install pip3. !!$end\n"


# finish text + tips
printf "\nSetup finished.\n\nPlease fix any errors(in$red red$end) that may have occured!.\n\nNote: Do run \"pip3 install requests\" if you dont already have done so!"

