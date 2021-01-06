# Manage and Create Projects (MCP)

## Features

- Setup new project environments.
- Add and create new repo's on github.
- Clone any repo with reponame and username.
- Setup virtualenv on any folder.
- Add environment veriables for choosen folder(env).

## Steps to setup MCP

- Add the MCP folder to the PATH.
- Add environment veriable: `GITHUB_USERNAME='github username'`
- Add environment veriable: `GITHUB_AUTH='github password or token'`
  - A token can be made at: *github.com > settings > developer settings > personal access token.*
  - make sure that you use the scopes: **repo, delete_repo.**
- Add environment veriable: `MCP_PATH='full path to the MCP folder'`
- Add `source mcp-auto.bash` to the config file that runs on terminal startup.
- Python and pip needs to be installed
  - Type `pip install virtualenv` in a terminal.
  - Type `pip install requests` in a terminal.
- Allow for file execution: `chmod 766 mcp`
- Type: `mcp help` in a terminal for usage information.

## Extra commands

- `activate` mcp will try to activate the closest environment.
- `autols` will toggle the `ls` command to automaticlly run after every `cd` command.

### Note

- If you are in a virtual environment that that dosen't have requests installed, then some commands may not work.
  - If thats the case, do the following:
    - Type `deactivate` (will deactivate the environment).
    - Type your *commands*.
    - Type `activate` (will activate the environment again).
- Some commands require that you have the environment activated.
  - The error msg will notify you if thats the case.
