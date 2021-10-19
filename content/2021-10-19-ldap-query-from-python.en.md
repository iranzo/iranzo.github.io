---
author: Pablo Iranzo Gómez
title: LDAP query from Python
tags: fedora, Linux, CentOS, RHEL, foss, python, LDAP,telegram
layout: post
date: 2021-10-19 22:34:34 +0200
comments: true
category: tech
description: This article describes how to use python to bind against an LDAP server and perform queries
lang: en
modified: 2021-09-30T16:41:47.119+02:00
---

Recently, some colleagues commented about validating if users in a Telegram group were or not employees anymore, so that the process could be automated without having to chase down the users that left the company.

One of the fields that can be configured by each user, is the link to other platforms (Github, LinkedIn, Twitter, Telegram, etc), so querying an LDAP server could suffice to get the list of users.

First, we need to get some data required, in our case, we do anonymous binding to our LDAP server and the field to search for containing the 'other platform' links.

We can do a simple query like this in Python:

```py
import ldap

myldap = ldap.initialize("ldap://myldapserver:389")
binddn = ""
pw = ""
basedn = "ou=users,dc=example,dc=com"
searchAttribute = ["SocialURL"]
searchFilter = "(SocialURL=*)"

# this will scope the entire subtree under UserUnits
searchScope = ldap.SCOPE_SUBTREE

# Bind to the server
myldap.protocol_version = ldap.VERSION3
myldap.simple_bind_s(binddn, pw)  # myldap.simple_bind_s() if anonymous binding is desired

# Perform the search
ldap_result_id = myldap.search(basedn, searchScope, searchFilter, searchAttribute)
result_set = []
while True:
    result_type, result_data = myldap.result(ldap_result_id, 0)
    if result_data == []:
        break
    else:
        if result_type == ldap.RES_SEARCH_ENTRY:
            result_set.append(result_data)

# Unbind from server
myldap.unbind_s()
```

At this point, the variable `result_set` will contain the values we want to filter, for example, the url containing the username in `https://t.me/USERNAME`form and the login id.

This, can be then acted accordingly and kick users that are no longer (or haven't configured Telegram username) in the LDAP directory.

Enjoy!
