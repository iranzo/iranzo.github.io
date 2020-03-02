---
author: Pablo Iranzo Gómez
title: Use custom domain name with Blog-O-Matic
tags: pelican, foss, travis, ci/cd, elegant, blog, python, github, blog-o-matic, linux
layout: post
date: 2019-05-16 22:29:14 +0200
comments: true
category: tech
description:
---

As a recipe, if you want to enable a custom domain name on [blog-o-matic]({filename}2019-01-09-blog-o-matic.md) a special file needs to be created on the 'GitHub Pages' served 'master' branch.

In order to do so, edit `pelicanconf.py` and add the following differences:

```diff
diff --git a/pelicanconf.py b/pelicanconf.py
index 680abcb..fc3dd8f 100644
--- a/pelicanconf.py
+++ b/pelicanconf.py
@@ -46,13 +46,16 @@ AMAZON_ONELINK = "b63a2115-85f7-43a9-b169-5f4c8c275655"


 # Extra files customization
-EXTRA_PATH_METADATA = {}
+EXTRA_PATH_METADATA = {
+    'extra/CNAME': {'path': 'CNAME'},
+}
+

 EXTRA_TEMPLATES_PATHS = [
     "plugins/revealmd/templates",  # eg: "plugins/revealmd/templates"
 ]

-STATIC_PATHS = [ 'images' ]
+STATIC_PATHS = [ 'images' , 'extra']


 ## ONLY TOUCH IF YOU KNOW WHAT YOU'RE DOING!
```

This will copy the `CNAME` file created in `content/extra/CNAME` to the resulting 'master' branch as `/CNAME`.

This file is interpreted by Github pages server as the domain name to listen for, so your website will start to be available from it (supposing that you followed usual requirements):

```bind
yourcustomdomain.es.	1	IN	A	185.199.108.153
yourcustomdomain.es.	1	IN	A	185.199.109.153
yourcustomdomain.es.	1	IN	A	185.199.110.153
yourcustomdomain.es.	1	IN	A	185.199.111.153
```

Please, do review if the serving servers have been updated on github pages!
