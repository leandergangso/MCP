# Manage and Create Projects (MCP)

Tested on both Windows and Linux.

- using cmder on Windows.
- using Ubuntu Linux.

## Features

- Create a repo on github and connect to new foler on local machine.
- Clone a repo from github to local machine.
- Delete repo from github. (local version will still be intact)
- Toggle repo visibility. (private/public)
- Get a list of all your repo's.
- Change repo description.
- Setup virtual environment on any folder.
- Create, see and delete 'folder based' environment variables.
- Automatic environment activation and deactivation.
- `activate` command instead of the use of eks: `source /.env/bin/activate` (can be executed within lower folders)
- Automatic `ls` after performed `cd` command. (default: is ignored if dir contains more than 20 items)

## Automatic setup (Linux)

- After the download, locate the script: `mcp-setup.bash`
- Run the script like so:
  - Linux: `sudo mcp-setup.bash`
    - You may need to run: `chmod 755 mcp-setup.bash` (make it executable)
  - Windows: `mcp-setup.bash` (run CMD as ADMIN)
- Go through the setup process.
- Done!
  - If you had a problem, please do create an issue.

## Manual setup (Linux, Windows)

- Add the MCP folder to the PATH: `/etc/environment`
- Add environment variable: `GITHUB_USERNAME='github username'`
- Add environment variable: `GITHUB_AUTH='github token'`
  - A token can be made at: *github.com > settings > developer settings > personal access token.*
  - make sure that you use the scopes: **repo, delete_repo**
- Optional: add `source mcp-auto.bash` to the config file that runs on terminal startup. (will allow for 'extra commands')
- Python3 and pip3 needs to be installed
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
