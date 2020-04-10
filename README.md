# MCP
## Features:
- Setup new project environment with out without github.
- Create a new repo on github.
- Clone your own repos to yout machine.
- Clone any repo with reponame and username.
- Setup virtualenv on any folder.
- Create local environment veriables only for choosen environment.
## Steps to setup MCP:
- Add the MCP folder to the PATH.
- Add environment veriable: GITHUB_USERNAME=(github username).
- Add environment veriable: GITHUB_AUTH=(github password or token).
  - A token can be made at: github.com > settings > developer settings > personal access token.
  - make sure that you use the scopes: repo, delete_repo
- Add environment veriable: MCP_PATH=(full path to the MCP folder).
- Add "source mcp_auto.bash" to the config file that runs on terminal startup.
- Type "pip install virtualenv" in a terminal. (requires pip already installed)
- Type: 'mcp help', for usage information.
