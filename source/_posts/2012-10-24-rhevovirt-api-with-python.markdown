---
layout: post
title: RHEV/OVIRT API with Python
date: '2012-10-24T13:38:00.003+02:00'
author: Pablo Iranzo Gómez
tags: python, rhev, ovirt
category: programming
modified_time: '2012-10-25T01:50:16.848+02:00'
blogger_id: tag:blogger.com,1999:blog-4564313404841923839.post-1003448890473219410
blogger_orig_url: http://iranzop.blogspot.com/2012/10/rhevovirt-api-with-python.html
---

RHEV/OVIRT api allows faster and simple development of scripts / utilities ranging from gathering of information to VM/host, etc manipulation.


For example, a simple script for connecting to API and list VM's could be:

{% highlight python %}
import sys
import getopt
import optparse
import os
import time

from ovirtsdk.api import API
from ovirtsdk.xml import params
from random import choice

baseurl = "https://localhost:8443"
api = API(url=baseurl, username="admin@internal",password="redhat",insecure=True)

for vm in api.vms.list():
    print vm.name

{% endhighlight %}

The `.list()` method works pretty well, but beware, it limits collections to 100 elements for performance reasons, so in those cases, we'll need to check how many results do we have, and paginate by passing an extra argument to our ".list()" invocation, for example:

{% highlight python %}
for vm in api.vms.list(query="page 1")
{% endhighlight %}

Furthermore, we can check the number of results by using:
{% highlight python %}
len(api.vms.list(query="page 1"))
{% endhighlight %}

And playing together, we could set a list that returns all results by running:

{% highlight python %}

vms = []
page = 0
length = 100
while (length > 0):
    page = page + 1
    query = "%s page %s" % (oquery, page)
    tanda = api.vms.list(query=query)
    length = len(tanda)
    for vm in tanda:
        vms.append(vm)

{% endhighlight %}

We can also make funny things like migrate VM's to another host by just running:





{% highlight python %}
vm.migrate()
{% endhighlight %}

It's expected for RHEV 3.1 to have a developer guide (now in Beta) at <https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Virtualization/3.1-Beta/html-single/Developer_Guide/index.html>

Check it for more examples of use and put the Virtualization to work for you!
