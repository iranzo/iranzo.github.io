---
layout: post
title: Contributing to OpenStack
date: 2016-07-21 17:32:47 +0200
comments: true
tags: python, OpenStack, foss
category: blog
description:
---

Contributing to an opensource project might take some time at the beginning, the good thing with OpenStack is that there are lot of guides on how to start and collaborate.

What I did is to look for a bug in the project tagged as [low-hanging-fruit](https://bugs.launchpad.net/openstack/+bugs?field.tag=low-hanging-fruit&orderby=status&start=0), this allows to browse a large list of bugs that are classified as `easy`, so they are the best place for new starters to get familiar with the workflow.

I did found an issue with `weight` which is supposed to be an integer, that was doing a conversion from float to integer (0.1 -> 0) which was considered invalid, and instead an error should be returned.

When I checked the `Neutron-LBaaS` I found out where the problem was, as the value provided, was being converted to integer instead of validating it.

Before contributing you need to:

- create a [Launchpad account](https://launchpad.net/+login),
- join the [OpenStack Foundation account](https://www.openstack.org/join/) as 'Foundation Member' and
- setup a <https://review.openstack.org/> account as described on [Account Setup](http://docs.openstack.org/infra/manual/developers.html#account-setup) section in the Developer's manual.
- Don't bypass the `git` configuration steps at above guide as we'll need them for next steps.

Submitting a change is quite easy:

~~~bash
# Select the project, 'neutron-lbaas' for me
each='neutron-lbaas'
git clone git@github.com:openstack/$each.git
cd $each
# This setups git-review, getting required hooks, etc
git-review -s
# create a new branch so we can keep our changes separate
git branch new-branch

# Edit files with changes
git add $files
git commit -m "Descriptive message"
# send  to upstream for review:
git-review
~~~

`git-review` will output an url you can use to preview your change, and the hooks will automatically add a 'Change-ID' so subsequent changes are linked to it.

NOTE: full reference is available at the [Developer's Guide](http://docs.openstack.org/infra/manual/developers.html)

The biggest `issue` started here:

- In order to not require a new function to validate integers, I've used the one for `non-negative` which already does this tests, but one of the reviewers suggested to write a function
- Functions were imported from `neutron-lib` so  I submitted a second change to `neutron-lib` project
- As the change in neutron-lib couldn't be marked as dependent as `neutron-lbaas` uses the  build the version already published, I had to define another *interim* version of the function so that `neutron-lbaas` can use it in the meantime and raise another bug, to later remove this interim function once than `neutron-lib` includes the validate_integer function
- As part of the comments on `neutron-lib` review, it was found that it would be nice to validate values, so after some discussion, I moved to use the internal `validate_values`.
- Of course, `validate_values` is just doing `data in valid_values`, so it fails if `data` or `valid_values` are not comparable and doesn't do conversion of depending on the values itselves, so this spin-off another review for improving the ´validate_values´ function.

At the moment, I'm trying to close the one to neutron-lib to use the function already defined, and have it merged, and then continue with the other steps, like removing the interim function in `neutron-lbaas` and work on enhancing `validate_values` and close all the dependant launchpad bugs I've created for tracking.

My experience so far, is that sometimes it might be a bit difficult, as git-review is a collaborative environment so different opinions are being shared with different approachs and some of them are 'easier' and some others 'pickier' like having an 'extra space', etc.

Of course, all the code is checked by some automation engines when submitted, which validates that the code still builds, no formatting errors, etc but many of them can be executed locally by using `tox`, which allows to perform part of the tests like:

- `tox -e pep8`
- `tox -e py27`
- `tox -e coverage`

To respectively, validate pep8 formatting (line length, spaces around operators, docsstrings formatting, etc) and to run another set of tests like the ones you define.

After each set of changes performed to apply the feedback received, ensure to:

~~~bash
# Add the modified files to a commit

git add $files_modified

# Create the commit with the changes

git commit -m "whatever"

# This will show you the last two commits, so you can leave the first one and
# on the beginning of the second one,
# replace 'pick' for 'f' so the changes are merged with first one without
# keeping the commit message

git rebase -i HEAD~2

# Fix the commit message if needed  (like fixing formatting,
# set dependant commits, or bugs it closes, etc)

git commit --amend

# Submit changes again for review

git-review
~~~

Also, keep in mind that apart from submitting the code change is important to submit automated validation tests, which can be executed with  `tox -e py27` to view that the functions return the values we expect even if the input data is out of what it should be, or like coverage, to validate that the code is covered (check on `tox.ini` what is defined).

And last but not least, expect to have lot of comments on more serius changes like changes to stable libs, as lot of reviewers will come to ensure that everything looks good and might even discuss it on the regular meetings to ensure, that a change is a good fit for the product in the proposed approach.
