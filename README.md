# Manage and Create Projects (MCP)

## Features

- Setup new project environments.
- Add and create new repo's on github.
- Clone any repo with reponame and username.
- Setup virtualenv on any folder.
- Add environment veriables for choosen folder(env).

## Steps to setup MCP

- Add the MCP folder to the PATH: `/etc/environment`
- Add environment veriable: `GITHUB_USERNAME='github username'`
- Add environment veriable: `GITHUB_AUTH='github token'`
  - A token can be made at: *github.com > settings > developer settings > personal access token.*
  - make sure that you use the scopes: **repo, delete_repo**
- Optional: add `source mcp-auto.bash` to the config file that runs on terminal startup. (will allow for 'extra commands')
- Python3 and pip needs to be installed
  - Type `pip install requests` in a terminal.
- Allow for file execution: `chmod 766 mcp`
- Type: `mcp help` in a terminal for usage information.

## Extra commands (only works if you have setup mcp-auto.bash)

- `activate` mcp will try to activate the closest environment.
- `autols` will toggle the `ls` command to automaticlly run after every `cd` command.
  - is disabled by default.
  - if directory contains more than 20 items, `ls` will not run.
    - 20 is the default value
    - edit default value with `autols item_count` (item_count needs to be a number)

### Note

- If you are in a virtual environment that that dosen't have requests installed, then some commands may not work.
  - If thats the case, do the following:
    - Type `deactivate` (will deactivate the environment).
    - Type your *commands*.
    - Type `activate` (will activate the environment again).
- Some commands require that you have the environment activated.
  - The error msg will notify you if thats the case.
