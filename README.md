# Manage and Create Projects (MCP)
## Features:
- Setup new project environments.
- Add and create new repo's on github.
- Clone any repo with reponame and username.
- Setup virtualenv on any folder.
- Add environment veriables for choosen folder(env).
## Steps to setup MCP:
- Add the MCP folder to the PATH.
- Add environment veriable: `GITHUB_USERNAME=(github username)`
- Add environment veriable: `GITHUB_AUTH=(github password or token)`
  - A token can be made at: *github.com > settings > developer settings > personal access token.
  - make sure that you use the scopes: **repo, delete_repo
- Add environment veriable: `MCP_PATH=(full path to the MCP folder)`
- Add `source mcp_auto.bash` to the config file that runs on terminal startup.
- Python and pip need to be installed
- Type `pip install virtualenv` in a terminal.
- Type: `mcp help` in a terminal for usage information.
