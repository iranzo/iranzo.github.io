---
author: Pablo Iranzo Gómez (pablo.iranzo@gmail.com)
title: Triggering a travis-ci build on another repo
tags: pelican, Foss, travis, ci/cd, elegant, blog, python
layout: post
date: 2018-12-11 21:49:47 +0100
comments: true
category: blog
description:
---

**Table of contents**
<!-- TOC depthFrom:1 insertAnchor:true orderedList:true -->

- [Introduction](#introduction)
- [The technical solution](#the-technical-solution)

<!-- /TOC -->

<a id="markdown-introduction" name="introduction"></a>
# Introduction

After setting up [build automation]({filename}2018-12-07-elegant-website-ci.md) we also wanted it not to happen only when updating the `documentation` repository.

As Elegant website is not only the documentarton repository but also the 'live' demo of the current branch, we do want to keep it updated not only when a document is added, but also when elegant templates are updated.

Github and Travis doesn't allow by default to use dependant builds, so the trick goes to 'signal' via a github token to trigger a travis-ci build.

<a id="markdown-the-technical-solution" name="the-technical-solution"></a>
# The technical solution

The approach goes via tweaking the 'test validation' `.travis.yaml` and adding some more steps:

The initial file (similar to the one in our previous article, but for running the 'page build' with latest repo checkout) looks like:

```yaml
# Copyright (C) 2017, 2018 Pablo Iranzo Gómez <Pablo.Iranzo@gmail.com>

language: python
dist: trusty
sudo: required

python:
- '3.5'

# prepare and move data for execution

before_install:
- pip install -U pip
- pip install -U setuptools
- pip install -r tests/requirements.txt
- pip install -r tests/test-requirements.txt
- pip install peru
- mkdir -p tests/themes/elegant
- mv templates tests/themes/elegant/
- mv static tests/themes/elegant/
- cd tests && peru sync 

script:
- pelican content/ -o output/
```

Is then modified to add:

~~~yaml
before_script:
- npm install travis-ci

after_success:
- node trigger-build.js
~~~

This does in fact, install travis-ci utilities and does run a custom script 'trigger-build.js' with node that does actually trigger Travis build.

The script, downloaded from [here](http://kamranicus.com/blog/2015/02/26/continuous-deployment-with-travis-ci/) has been tweaked to specify the 'repo' we will trigger and the name of the environment variable containing the token:

```js
var Travis = require('travis-ci');

// change this
var repo = "Pelican-Elegant/documentation";

var travis = new Travis({
	version: '2.0.0'
});

travis.authenticate({

	// available through Travis CI
	// see: http://kamranicus.com/blog/2015/02/26/continuous-deployment-with-travis-ci/
	github_token: process.env.TRATOKEN

}, function (err, res) {
	if (err) {
		return console.error(err);
	}

	travis.repos(repo.split('/')[0], repo.split('/')[1]).builds.get(function (err, res) {
		if (err) {
			return console.error(err);
		}

		travis.requests.post({
			build_id: res.builds[0].id
		}, function (err, res) {
			if (err) {
				return console.error(err);
			}
			console.log(res.flash[0].notice);
		});
	});
});
```

As you can see, it grabs the github token from environment variable 'TRATOKEN' that we've defined in travis-ci environment for the build, similar to what we did in the documentation repo to push the built website to another repo.

With all the solution in place, when a new commit is merged on 'master' branch on the 'theme' repo (`elegant`), travis does get invoked to schedule a build on the `documentation` repo, thus, rendering the live website with latest templates.

Enjoy!
Pablo