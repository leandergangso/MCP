import requests
import json
import sys
import os

#--------------#
# DEF SELECTOR #
#--------------#

def selector(arg):
    switch = {
        'createRepo': createRepo,
        'cloneRepo': cloneRepo,
        'delRepo': delRepo,
        'descRepo': descRepo,
        'repoList': repoList,
        'gitVisibility': gitVisibility,
    }
    # get the case
    case = switch.get(arg, 'error')
    if case == 'error':
        print('error, invalid case')
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
        print(r.json()['message'])
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
    print('creating new repo...')
    # test for existing repo
    data = _getRepo()
    for repo in data.json():
        if repo['name'].lower() == arg_list[3].lower():
            print('error, repo already exist.')
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
        print('repo created')
        sys.exit(0)
    else:
        print(r.json()['message'])
        sys.exit(1)

# check for valid repo name
def cloneRepo():
    print('checking existing repos...')
    # confirm repo
    if _confirmRepo():
        # user info
        print('repo found')
        # return valid repo
        sys.exit(0)
    else:
        print('no repo exist with the name:',arg_list[3])
        # return invalid repo
        sys.exit(1)

# delete repo from github
def delRepo():
    print('checking existing repos...')
    # confirm repo name
    if _confirmRepo():
        print('found repo, deleting...')
        # get user auth
        auth = (arg_list[1], arg_list[2])
        # modify base url
        url = base+'repos/'+arg_list[1]+'/'+arg_list[3]
        # send delete request to api
        r = requests.delete(url, auth=auth)
        # check responcse
        if r.ok:
            print('repo deleted')
            sys.exit(0)
        else:
            print(r.json()['message'])
            sys.exit(1)
    else:
        print('no repo exist with the name:',arg_list[3])
        # return invalid repo
        sys.exit(1)

# add/change repo description
def descRepo():
    print('changing repo description...')
    # confirm repo name
    if _confirmRepo():
        print('found repo, updating...')
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
            print('description changed')
            sys.exit(0)
        else:
            print(r.json()['message'])
            sys.exit(1)
    else:
        print('no repo exist with the name:',arg_list[3])
        # return invalid repo
        sys.exit(1)

# get repos from github
def repoList():
    print('Github repo list:')
    # get repo list
    data = _getRepo()
    # display info
    for repo in data.json():
        print('         name: ',repo['name'])
        print('  description: ',repo['description'])
        print('      private: ',repo['private'])
        print('-----------------------------------')
    sys.exit(0)

# change repo visibility
def gitVisibility():
    print('changing repo visibility...')
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
            print('done, private =',private)
            sys.exit(0)
        else:
            print(r.json()['message'])
            sys.exit(1)
    else:
        print('no repo exist with the name:',arg_list[3])
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