---
layout: post
title: Contributing to OSP upstream a.k.a. Peer Review
date: 2018-10-16 07:32:47 +0200
comments: true
tags: python, OpenStack, foss, git, Gerrit, RDO, fedora, citellus, risu
category: tech
description:
---

[TOC]

## Introduction

In the article "[Contributing to OpenStack]({filename}2016-07-21-contributing-to-openstack.en.md)" we did cover on how to prepare accounts and prepare your changes for submission upstream (and even how to find `low hanging fruits` to start contributing).

Here, we'll cover what happens behind the scene to get change published.

## Upstream workflow

### Peer review

Upstream contributions to OSP and other projects are based on Peer Review, that means that once a new set of code has been submitted, several steps for validation are required/happen before having it implemented.

The last command executed (`git-review`) on the submit sequence (in the prior article) will effectively submit the patch to the defined git review service (`git-review -s` does the required setup process) and will print an URL that can be used to access the review.

Each project might have a different review platform, but usually for OSP it's <https://review.openstack.org> while for other projects it can be <https://gerrit.ovirt.org>, <https://gerrithub.io>, etc (this is defined in `.gitreview` file in the repository).

A sample `.gitreview` file looks like:

```ini
[gerrit]
host=review.gerrithub.io
port=29418
project=citellusorg/citellus.git
```

For a review example, we'll use one from gerrithub from [Citellus](https://risuorg.github.io) project:

<https://review.gerrithub.io/#/c/380646/>

Here, we can see that we're on review `380646` and that's the link that allows us to check the changes submitted (the one printed when executing `git-review`).

### CI tests (Verified +1)

Once a review has been submitted, usually the bots are the first ones to pick them and run the defined unit testing on the new changes, to ensure that it doesn't break anything (based on what is defined to be tested).

This is a critical point as:

- Tests need to be defined if new code is added or modified to ensure that later updates doesn't break this new code without someone being aware.
- Infrastructure should be able to test it (for example you might need some specific hardware to test a card or network configuration)
- Environment should be sane so that prior runs doesn't affect the validation.

OSP CI can be checked at 'Zuul' <http://zuul.openstack.org/> where you can 'input' the number for your review and see how the different bots are running CI tests on it or if it's still queued.

If everything is OK, the bot will 'vote' your change as `Verified +1` allowing others to see that it should not break anything based on the tests performed

In the case of OSP, there's also third-party CI's that can validate other changes by third party systems. For some of them, the votes are counting towards or against the proposed change, for others it's just a comment to take into account.

Even if sometimes you know that your code is right, there's a failure because of the infrastructure, in those cases, writing a new comment saying `recheck`, will schedule a new CI test run.

This is common usually during busy periods when it's harder for the scheduler to get available resources for the review validation. Also, sometimes there are errors in the configuration of CI that must be fixed in order to validate those changes.

Note: you can run some of the tests on your system to validate faster if you've issues by running `tox` this will setup virtual environment for tests to be run so it's easier to catch issues before upstream CI does (so it's always a good idea to run `tox` even before submitting the review with `git-review` to detect early errors).

This is however not always possible as some changes include requirements like testing upgrades, full environment deployments, etc that cannot be done without the required preparation steps or even the infrastructure.

### Code Review+2

This is probably the 'longest' process, it requires peers to be added as 'reviewer' (you can get an idea on the names based on other reviews submitted for the same component) or they will pick up new reviews as the pop un on notification channels or pending queues.

On this, you must prepare mentally for everything... developers could suggest to use a different approach, or highlight other problems or just do some small `nit` comments to fixes like formating, spacing, var naming, etc.

After each comment/change suggested, repeat the workflow for submitting a new patchset, but make sure you're using the same review id (that's by keeping the commit id that is appended): this allows the Code Review platform to identify this change as an update to a prior one, and allow you for example to compare changes across versions, etc. (and also notify the prior reviewers of new changes).

Once reviewers are OK with your code, and with some 'Core' developers also agreeing, you'll see some voting happening (-2..+2) meaning they like the change in its actual form or not.

Once you get `Code Review +2` and with the prior `Verified +1` you're almost ready to get the change merged.

### Workflow+1

Ok, last step is to have someone with Workflow permissions to give a +1, this will 'seal' the change saying that everything is ok (as it had CR+2 and Verified+1) and change is valid...

This vote will trigger another build by CI, and when finished, the change will be merged into the code upstream, congratulations!

### Cannot merge, please rebase

Sometimes, your change is doing changes on the same files that other programmers did on the code, so there's no way to automatically 'rebase' the change, in this case the bad news is that you need to:

```sh
git checkout master # to change to master branch
git pull # to push latest upstream changes
git checkout yourbranch # to get back to your change branch
git rebase master # to apply your changes on top of current master
```

After this step, it might be required to manually fix the code to solve the conflicts and follow instructions given by git to mark them as reviewed.

Once it's done, remember to do like with any patchset you submitted afterwards:

```sh
git commit --amend # to commit the new changes on the same commit Id you used
git-review # to upload a new version of the patchset
```

This will start over the progress, but will, once completed to get the change merged.

## How do we do it with Citellus?

In [Citellus](https://risuorg.github.io/) we've replicated more or less what we've upstream... even the use of `tox`.

Citellus does use <https://gerrithub.io> (free service that hooks on github and allows to do PR)

We've setup a machine that runs [Jenkins]({filename}2017-08-17-Jenkins-for-running-CI-tests.en.md) to do 'CI' on the tests we've defined (mostly for python wrapper and some tests) and what effectively does is to run `tox`, and also, we do use <https://travis-ci.org> free Tier to repeat the same on other platform.

`tox` is a tool that allows to define several commands that are executed inside python virtual environments, so without touching your system libraries, it can get installed new ones or removed just for the boundaries of that test, helping into running:

- pep8 (python formating compliance)
- py27 (python 2.7 environment test)
- py35 (python 3.5 environment test)

The `py*` tests are just to validate the code can run on both base python versions, and what they do is to run the defined unit testing scripts under each interpreter to validate.

For local test, you can run `tox` and it will go trough the different tests defined and report status... if everything is ok, it should be possible that your new code review passes also CI.

Jenkins will do the +1 on verified and 'core' reviewers will give +2 and 'merge' the change once validated.

Hope you enjoy!

Pablo
