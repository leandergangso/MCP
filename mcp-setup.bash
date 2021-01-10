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


# add mcp folder to PATH
if [[ -a "/etc/environment" ]] ; then
    # check if done before

    # cp /etc/environment /etc/environment.mcp_bak
    # environment_content=$(cat /etc/environment | cut -d '"' -f 2)
    # printf "PATH=\"$environment_content:$MCP_DIR\"\n" > /etc/environment
    printf "Added: $MCP_DIR to /etc/environment. (backup created)\n"
else
    printf "$red!! The file 'environment' do not exist, STEP.1 has to be done MANUALLY. !!$end\n"
fi


# add username
printf "\nAdding GITHUB variables:\n"
while true; do
    read -p "Enter your GITHUB username:" USERNAME
    read -p "Is this your username, $USERNAME [y,n]" yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) ;;
        * ) printf "Invalid input, try again.\n";;
    esac
done


# check for existing PAT
while true; do
    read -p "Do you have a Personal Access Token (PAT)? [y,n]" yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) printf "Create PAT here: https://github.com/settings/tokens \nNote: the PAT needs to have 'REPO' and 'DELETE_REPO' tagged.\n" && break;;
        * ) printf "Invalid input, try again.\n";;
    esac
done


# ask for PAT
while true; do
    read -p "Enter you PAT:" PAT
    read -p "Is this your PAT, $PAT [y,n]" yn
    case $yn in
        [Yy] ) printf "Saving PAT to .profile\n" && break;;
        [Nn] ) printf "\n";;
        * ) printf "Invalid input, try again.\n";;
    esac
done


# locate .profile or .bashrc
cd ~
if [[ -a ".profile" ]]; then
    FILE=".profile"
else
    if [[ -a ".bashrc" ]]; then
        FILE=".bashrc"
    else
        read -p "Enter path to .bashrc or .profile:" FILE
    fi
fi


# save to FILE
if ! grep -q "export GITHUB_USERNAME" $FILE; then
    printf "export GITHUB_USERNAME=\"$USERNAME\"\n" >> $FILE
fi
if ! grep -q "export GITHUB_AUTH" $FILE; then
    printf "export GITHUB_AUTH=\"$PAT\"\n" >> $FILE
fi
printf "GITHUB variables added successfully.\n"


# add mcp-auto.bash to FILE
if ! grep -q "mcp-auto.bash" $FILE; then
    printf "source mcp-auto.bash\n" >> $FILE
    printf "mcp-auto.bash added to $FILE.\n"
fi


# check if python3 and pip3 is installed
type -P python3 >/dev/null 2>&1 && printf "Python3 is installed.\n" || printf "$red!! You need to install python3. !!$end\n"
type -P pip3 >/dev/null 2>&1 && printf "Pip3 is installed.\n" || printf "$red!! You need to install pip3. !!$end\n"


# set correct chmod
cd $MCP_DIR
chmod 755 mcp
chmod 755 mcp-api.py
chmod 644 mcp-auth.bash
rm -rf mcp-setup.bash


# finish text + tips
printf "Setup finished.\n\nPlease fix any errors(in red) that may have occured!\nNote: mcp-setup.bash has been deleted as it's no longer needed."

