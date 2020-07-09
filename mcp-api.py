import os
import sys
import json
try:
    import requests
except:
    # error message
    print("Error, 'requests' is not installed.\nTry again after disabling active 'env', or type: `pip install requests`.")
    # exit script
    sys.exit(1)

#--------------#
# DEF SELECTOR #
#--------------#

def selector(arg):
    switch = {
        'createRepo': createRepo,
        'delRepo': delRepo,
        'descRepo': descRepo,
        'repoList': repoList,
        'gitVisibility': gitVisibility,
    }
    # get the case
    case = switch.get(arg, 'error')
    if case == 'error':
        sys.stdout.write('error, invalid case\n')
    else:
        # run the case
        case()

#------------#
# HELPER DEF #
#------------#

# get repo list
def _getRepo():
    # get user auth
    auth = (arg_list[1],arg_list[2])
    # modify url
    url = base+'user/repos'
    # get repo from api
    r = requests.get(url, auth=auth)
    # check response
    if r.ok:
        return r
    else:
        sys.stdout.write('%s\n' %r.json()['message'])
        sys.exit(1)

# confirm that given repo exist
def _confirmRepo():
    # get repos
    data = _getRepo()
    # look for match
    for repo in data.json():
        if arg_list[3].lower() == repo['name'].lower():
            # repo found
            return True
    # no matching repo names
    return False

#--------#
# GITHUB #
#--------#

# create a new repo on github
def createRepo():
    sys.stdout.write('creating new repo...\n')
    # test for existing repo
    data = _getRepo()
    for repo in data.json():
        if repo['name'].lower() == arg_list[3].lower():
            sys.stdout.write('error, repo already exist.\n')
            sys.exit(1)
    # get user auth
    auth = (arg_list[1], arg_list[2])
    # modify base url
    url = base+'user/repos'
    # set true/false
    arg_list[5] = True if arg_list[5] == 'true' else False
    # new repo data
    data = json.dumps({"name": arg_list[3], "description": arg_list[4], "private": arg_list[5]})
    # post new repo to api
    r = requests.post(url, auth=auth, data=data)
    # check responcse
    if r.ok:
        sys.stdout.write('repo created\n')
        sys.exit(0)
    else:
        sys.stdout.write('%s\n' %r.json()['message'])
        sys.exit(1)

# delete repo from github
def delRepo():
    sys.stdout.write('checking existing repos...\n')
    # confirm repo name
    if _confirmRepo():
        sys.stdout.write('found repo, deleting...\n')
        # get user auth
        auth = (arg_list[1], arg_list[2])
        # modify base url
        url = base+'repos/'+arg_list[1]+'/'+arg_list[3]
        # send delete request to api
        r = requests.delete(url, auth=auth)
        # check responcse
        if r.ok:
            sys.stdout.write('repo deleted\n')
            sys.exit(0)
        else:
            sys.stdout.write('%s\n' %r.json()['message'])
            sys.exit(1)
    else:
        sys.stdout.write('no repo exist with the name: %s\n' %arg_list[3])
        # return invalid repo
        sys.exit(1)

# add/change repo description
def descRepo():
    sys.stdout.write('changing repo description...\n')
    # confirm repo name
    if _confirmRepo():
        sys.stdout.write('found repo, updating...\n')
        # get user auth
        auth = (arg_list[1], arg_list[2])
        # modify base url
        url = base+'repos/'+arg_list[1]+'/'+arg_list[3]
        # updated repo data
        data = json.dumps({"description":arg_list[4]})
        # send delete request to api
        r = requests.patch(url, auth=auth, data=data)
        # check responcse
        if r.ok:
            sys.stdout.write('description changed\n')
            sys.exit(0)
        else:
            sys.stdout.write('%s\n' %r.json()['message'])
            sys.exit(1)
    else:
        sys.stdout.write('no repo exist with the name: %s\n' %arg_list[3])
        # return invalid repo
        sys.exit(1)

# get repos from github
def repoList():
    # get repo list
    data = _getRepo()
    # display info
    for repo in data.json():
        sys.stdout.write('         name: %s\n' %repo['name'])
        sys.stdout.write('  description: %s\n' %repo['description'])
        sys.stdout.write('      private: %s\n' %repo['private'])
        sys.stdout.write('-----------------------------------\n')
    sys.exit(0)

# change repo visibility
def gitVisibility():
    sys.stdout.write('changing repo visibility...\n')
    # get user auth
    auth = (arg_list[1],arg_list[2])
    # modify url
    url = base+'repos/'+arg_list[1]+'/'+arg_list[3]
    # default state
    private = True
    # check repo name
    if _confirmRepo():
        # get repo visibility state
        data = _getRepo()
        for repo in data.json():
            if repo['name'].lower() == arg_list[3].lower():
                if repo['private']:
                    private = False
                else:
                    private = True
        # patch information
        data = json.dumps({'private': private})
        # send updated info
        r = requests.patch(url, auth=auth, data=data)
        # check response
        if r.ok:
            sys.stdout.write('done, private = %s\n' %private)
            sys.exit(0)
        else:
            sys.stdout.write('%s\n' %r.json()['message'])
            sys.exit(1)
    else:
        sys.stdout.write('no repo exist with the name: %s\n' %arg_list[3])
        # return invalid repo
        sys.exit(1)

#---------------#
# GET FROM BASH #
#---------------#

# base url
base = 'https://api.github.com/'

# argument list
arg_list = []

# get arguments from bash
for arg in sys.argv[1:]:
    arg_list.append(arg)

# run selector
selector(arg_list[0])
