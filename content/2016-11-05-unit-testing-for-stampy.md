---
layout: post
title: Unit testing for stampy
date: 2016-11-05 19:39:00 +0100
comments: true
tags: python, telegram, openstack, foss
category: blog
description:
---
Since my prior post on [Contributing to OpenStack]({filename}2016-07-21-contributing-to-openstack.md), I liked the idea of using some automated tests to validate functionality and specifically, the corner cases that could arise when playing with the code.

Most of the errors fixed so far on stampy, were related with some pieces of the code not properly handling UTF or some information returned, etc and still it has improved, the idea of ensuring that prior errors were not put back into the code when some other changes were performed, started to arise to be a priority.

For implementing them, I made use of `nose`, which can be executed with `nosetests` and are available on Fedora as 'python-nose' and to provide further automation, I've also relied on `tox` also inspired n what OpenStack does.

Let's start with `tox`: once installed, a new configuration file is created for it, defining the different environments and configuration in a similar way to:

~~~ini
[tox]
minversion = 2.0
envlist = py27,pep8
skipsdist = True

[testenv]
passenv = CI TRAVIS TRAVIS_*
deps = -r{toxinidir}/requirements.txt
       -r{toxinidir}/test-requirements.txt
commands =
    /usr/bin/find . -type f -name "*.pyc" -delete
    nosetests \
        []
[testenv:pep8]
commands = flake8

[testenv:venv]
commands = {posargs}

[testenv:cover]
commands =
  coverage report

[flake8]
show-source = True
exclude=.venv,.git,.tox,dist,doc,*lib/python*,*egg,build
~~~

This file, defines two environments, one for validating pep8 for the python formatting and another one for validating python 2.7.

The environment definition for the tests, also performs some commands like executed the forementioned `nosetests` to run the defined unit tests.

Above `tox.ini` also mentions `requirements.txt` and `test-requirements.txt`, which define the python packages required to validate the program, that will be automatically installed by tox on a `virtualenv`, so the alternate versions being used, doesn't interfere with the system-wide ones we're using.

About the tests themselves, as `nosetests` does automatic discovery of tests to perform, I've created a new folder named `tests/` and placed there some files in alphabetically order:

~~~bash
ls -l tests
total 28
-rw-r--r--. 1 iranzo iranzo  709 nov  5 16:58 test_00-setup.py
-rw-r--r--. 1 iranzo iranzo  739 nov  3 09:56 test_10-alias.py
-rw-r--r--. 1 iranzo iranzo  456 nov  3 23:53 test_10-autokarma.py
-rw-r--r--. 1 iranzo iranzo  581 nov  3 09:56 test_10-karma.py
-rw-r--r--. 1 iranzo iranzo 3544 nov  5 18:19 test_10-process.py
-rw-r--r--. 1 iranzo iranzo  477 nov  3 23:15 test_10-quote.py
-rw-r--r--. 1 iranzo iranzo  230 nov  3 09:56 test_10-sendmessage.py
~~~

First one `test_00-setup` takes the required commands to define the enviroment, as on each validation run of `tox`, a new environment should be available not to mask errors that could be overlooked.

~~~python
#!/usr/bin/env python
# encoding: utf-8

from unittest import TestCase

from stampy.stampy import config, setconfig, createdb, dbsql

# Precreate DB for other operations to work
try:
    createdb()
except:
    pass

# Define configuration for tests
setconfig('token', '279488369:AAFqGVesZ-81n9sFafLQxUUCVO8_8L3JNEU')
setconfig('owner', 'iranzo')
setconfig('url', 'https://api.telegram.org/bot')
setconfig('verbosity', 'DEBUG')

# Empty karma database in case it contained some leftover
dbsql('DELETE from karma')
dbsql('DELETE from quote')
dbsql('UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME="quote"')


class TestStampy(TestCase):
    def test_owner(self):
        self.assertEqual(config('owner'), 'iranzo')
~~~

This file creates the database if none is existing and defines some sample values, like DEBUG level, url for contacting telegram API servers, or even a token that can be used to test the functionality for sending messages.

Also, if the database is already existing, empties the karma table, quotes (and sets sequence to 0 to simulate TRUNCATE which is not available on sqlite)

An unittest is specified under the class inherited from `TestCase` imported from `unittest`, there for each one of the tests we want to performed, a new 'definition' is created and after it an assert is used, for example `assertEqual` validates that the function call returns the value provided as secondary argument, failing otherwise.

From that point, the tests are performed again in ***alphabetically order***, so be careful in the naming of each tests or define a sequence number to use a top-to-bottom approach that will be probably easier to understand.

For example, for karma changes we've:

~~~python
#!/usr/bin/env python
# encoding: utf-8

from unittest import TestCase

from stampy.stampy import getkarma, updatekarma, putkarma


class TestStampy(TestCase):
    def test_putkarma(self):
        putkarma('patata', 0)
        self.assertEqual(getkarma('patata'), 0)

    def test_getkarma(self):
        self.assertEqual(getkarma('patata'), 0)

    def test_updatekarmaplus(self):
        updatekarma('patata', 2)
        self.assertEqual(getkarma('patata'), 2)

    def test_updatekarmarem(self):
        updatekarma('patata', -1)
        self.assertEqual(getkarma('patata'), 1)

~~~

Which starts by putting a known karma on a word, validating, verifying the query, update the value by a positive number and later, decrease it with a negative one.

For the aliases, we use a similar aproach, as we also play with the karma changes when an alias is defined:

~~~python
#!/usr/bin/env python
# encoding: utf-8

from unittest import TestCase

from stampy.stampy import getkarma, putkarma, createalias, getalias, deletealias


class TestStampy(TestCase):

    def test_createalias(self):
        createalias('patata', 'creilla')
        self.assertEqual(getalias('patata'), 'creilla')

    def test_getalias(self):
        self.assertEqual(getalias('patata'), 'creilla')

    def test_increasealiaskarma(self):
        updatekarma('patata', 1)
        self.assertEqual(getkarma('patata'), 1)

        # Alias doesn't get increased as the 'aliases' modifications are in
        # process, not in the individual functions
        self.assertEqual(getkarma('creilla'), 0)

    def test_removealias(self):
        deletealias('patata')
        self.assertEqual(getkarma('creilla'), 0)

    def test_removekarma(self):
        putkarma('patata', 0)
        self.assertEqual(getkarma('patata'), 0)
~~~

Where an alias is created, verified, karma in creased on the word with an alias, and then the aliased value.

As noted in the above example, the individual function for the karma doesn't take into consideration the aliases so this must be handled by processing a message set via `process(messages)` which has been also modified as well as other functions to allow the implementation of individual tests for them.

This will for sure end up with some more code rewriting so the functions can be fully tested individually and as a whole, to ensure that the bot behaves as intended... and many more tests to come to the code.

As an end, an example of the execution of tox and the results raised:

~~~bash
tox
py27 installed: coverage==4.2,nose==1.3.7,prettytable==0.7.2
py27 runtests: PYTHONHASHSEED='604985980'
py27 runtests: commands[0] | /usr/bin/find . -type f -name *.pyc -delete
py27 runtests: commands[1] | nosetests
..................
----------------------------------------------------------------------
Ran 18 tests in 14.996s

OK
pep8 installed: coverage==4.2,nose==1.3.7,prettytable==0.7.2
pep8 runtests: PYTHONHASHSEED='604985980'
pep8 runtests: commands[0] | flake8
WARNING:test command found but not installed in testenv
  cmd: /usr/bin/flake8
  env: /home/iranzo/DEVEL/private/stampython/.tox/pep8
Maybe you forgot to specify a dependency? See also the whitelist_externals envconfig setting.
__________________________________________________________________________ summary ___________________________________________________________________________
  py27: commands succeeded
  pep8: commands succeeded
  congratulations :)
~~~

If you're using a CI system, like 'Travis', which is also available to <https://github.com> repos, a `.travis.yml` can be added to the repo to ensure those tests are performed automatically on each code push:

~~~yaml
language: python
python:
    - 2.7

notifications:
    email: false

before_install:
    - pip install pep8
    - pip install misspellings
    - pip install nose

script:
    # Run pep8 on all .py files in all subfolders
    # (I ignore "E402: module level import not at top of file"
    # because of use case sys.path.append('..'); import <module>)
    - find . -name \*.py -exec pep8 --ignore=E402,E501 {} +
    - find . -name '*.py' | misspellings -f -
    - nosetests
~~~

Enjoy!
