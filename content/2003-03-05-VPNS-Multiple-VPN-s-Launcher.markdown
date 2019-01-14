---
layout: post
title: VPNS - Multiple VPN's Launcher
date: 2003-03-05T20:55:00Z
tags: linux, network, vpn, foss
comments: true
---

[TOC]

## General Purpose

The idea on writing vpn's and the structure it follows was the problem that we had into easily configure many vpn's for use with the wireless project interconnection (Valencia Wireless [`http://www.valenciawireless.org`](http://www.valenciawireless.org/)).

When having no chance to join networks using just wireless links, we needed to provide some kind of transparent link from one WiFi node to another. To do so, we decided to use the VPND daemon to establish links between our networks for allowing transparent traffic flow.

VPND it's great because it's very easy to configure and works fine, but has a little big problem... it doesn't allow to use DNS names for establishing VPN's, it just allows to use static IP's. Probably that wouldn't be a problem for big business, universities, etc but as wireless projects are common between particulars, and at least in Spain we usually have dynamic IP's, it made our tunnels to be "alive" until either our provider or the remote provider decides to change the IP...

All of us were using Dynamic DNS Services from different providers (I use No-IP ([http://www.no-ip.org](http://www.no-ip.org/)), so if you decide to sign it with them, please use the following link No-Ip [`http://www.no-ip.com/referral/index.php/client/Pablo.Iranzo@uv.es`](http://www.no-ip.com/referral/index.php/client/Pablo.Iranzo@uv.es)), other people at Valencia Wireless uses DynDNS [`http://www.dyndns.org`](http://www.dyndns.org/), if in doubt, search for Dynamic DNS to get an idea on what you can use...

In brief... we had DNS names that get dynamically resolved to our current IP's, but VPND was unable to deal with those names... so I wrote VPNS :-D

(please, if you use it, send me an email to let me know how much people is using it... thanks)

## Requirements

VPNS, it's just a bunch of configuration files and three scripts that requires the presence of:

- Perl (for the scripts)
- Bash or compatible (for the startup script)
- VPND (for the VPN establishing)
- Ping (for resolving DNS names to Ip's)

**CAUTION:**:   As this is just a gzipped-tar file by the moment, you'll have to check that the required software is installed before trying to use it.

This script has been created for a Debian GNU/Linux distribution, but as far as I can remember it's compatible with the schema used on Red Hat, SuSE, etc... but check before

## The way it works...

As VPND requires one key file (vpnd.key), and a configuration file (vpnd.conf) for each connection, the idea was to split different files for each node.

We'll require then one key file and one configuration file for each node to be able to spawn a VPND daemon with those data.

As each VPND will require both static origin and target IP's there would be some things that would be static in the configuration (other parameters) and others that would need to get rewritten (target, and start addresses).

## Configuration files

The configuration get's deployed on two directories: /etc/vpnd/ for the local host configuration (your host) and /etc/vpnd/hosts/* for the remote hosts configuration.

There are also some rc?.d directories with symbolic links to vpns to start/stop the daemon at different runlevels, it's a good idea to copy them too, but as the main purpose of this script is to periodically test it, it should be included at crontab (as well as rc?.d to initial startup).

### 4.1 Local Configuration

Those files specify the configuration for the local host that will be used by all the other hosts.

- **/etc/vpnd/master.resolv :** :   In this file you'll need to put the Dynamic DNS name of your machine (in my case "lacreu.no-ip.org"), so the update script will get your IP from it to be able to establish tunnels both if your IP changes or just if remote IP changes.
- **/etc/vpnd/master.ip :** :   This file is created automatically with the results of resolving your Dynamic DNS to an IP to allow comparison between your last IP and your current to check if you need to relaunch VPN's (remember that the worst case is both local and remote IP's getting changed).
- **/etc/vpnd/master.restart :** :   This file is created when local IP has changed, specifying a total VPND restart for all VPN's

### 4.2 Host configuration (/etc/vpnd/hosts/$HOST)

Each file in this subdir specifies a VPN to be launched and defines the name that the configuration files would have appended.

We'll create a folder for each remote host with a descriptive name that would be use by the scripts.

**CAUTION:** :   For creating the files you'll have to use "echo "client" > mode" or similar (for port, resolv, mode, etc), there have been some problems with files not created this way (and my perl knowledge doesn't allow me to do anything better).

Into this subdir there would be the following config files:

#### 4.2.1 Static files

- **vpnd.key :** :   Cipher key that would be used for the connection with the remote host. It gets created by VPND or copied from remote host.
- **mode :** :   Mode that we use to get connected to remote host (server or client)
- **port :** :   Port at wich the connection gets established
- **resolv :** :   Dinamic DNS resolver name for the target host (used for resolving it's IP)
- **master :** :   Master configuration file for HOST (the config that it's static)

#### 4.2.2 Dinamic files

- **vpnd.conf :** :   Configuration file for HOST, it gets created automatically when running /etc/vpnd/update.pl script
- **restart :** :   This file gets created by the "compare.pl" script to indicate that VPNS should restart this host VPN. This file is created if the IP has changed since last launch

#### 4.2.3 Scripts

- **/etc/vpnd/update.pl :** :   Script to merge configuration files for host, resolve IP and then output a vpnd.conf file for that host
- **/etc/vpnd/compare.pl :** :   Script to compare IP's between recorded one and current for preparing VPND restart
- **/etc/init.d/vpns :** :   Script to start, stop, restart or restart-if-needed the VPNS based on hosts definitions

## Recommendations

As probably IP's will change, you'll need to put a crontab sentence for checking of updated ip's, to do so, put /etc/init.d/vpns restart-if-needed in your crontab for allowing the tunnels to be recreated at every change.

Sample crontab line would be:

~~~cron
#!bash
0-59/5 * * * * root /etc/init.d/vpns restart-if-needed
~~~

This way, every five minutes, the script would be run and will restart VPNS that needed to do so.

At every run, compare.pl will check new IP addresses, and will mark the service to be restarted, it will create master.ip and "host/ip" file.

update.pl will dump a vpnd.conf file containing the merge of "host/master" and the Dinamic DNS for both local host and remote host configured as "host/mode" says using the "host/port" port to establish connection and vpnd.key file in each "host/" subdir.

## Changelog

### Version 0.43

Added a check (chop $mode) with the mode definition to fix problems in systems that always configured mode as server (default check, because the if sentence at update.pl searched for "client" and sometimes it was not well compared)

Thanks to Hawkmoon

### Version 0.42

Change in the compare.pl script for the case in which the changed ip was the local one to restart all vpn daemons.

Before this version, when local ip changed, only the first-checked VPN will be restarted as there was no file specifying a total restart.

### Version 0.41

Little changes in configuration files an scripts to make it easier to set up, please, check your configuration files to use new behaviour

- pid file now gets automatically defined to match vpns kill procedure, so it shouldn't be in "master" file.

### Version 0.4

Now, added localhost IP resolution to check if just origin or end (or both) changed their IP, so if either one of them changes, the VPN get's marked as restart-needed.

### Version 0.3

Each host is now restarted only if needed. (added vpns restart-if-needed command) for not having to stop/relaunch every VPN at every time.

Added compare.pl script to compare IP's and to let inform the vpns that needs to restart it.

### Version 0.2

Configuration files moved from /etc/vpnd/ to /etc/vpnd/hosts/*, so each host has it's configuration files into one subdirectory, allowing to tidy the things a bit. Old files were named vpnd-HOST.conf, vpnd-HOST.key, HOST.resolv,etc. They got renamed and moved to the actual location.

### Version 0.1

First version: at every restart of VPNS new configuration files were created for each host, and then the VPND were restarted with the configuration files

## Sample configuration files

Here you will see a sample files used at my host, the other files not dumped here are created automatically by the scripts or you must create them manually (for example the vpnd.key).

### 7.1 Local

### 7.1.1 master.resolv

`merak.no-ip.org`

### 7.2 Remote Host

#### 7.2.1 mode

`server`

#### 7.2.2 port

`2010`

#### 7.2.3 resolv

`oceano.dyndns.org`

#### 7.2.4 master

- **local** :   172.16.97.78
- **remote** :   172.16.97.77
- **autoroute** :   **keepalive** :   10
- **noanswer** :   3
- **keyfile** :   vpnd.key
- **randomdev** :   /dev/urandom mtu 1600

### 7.3 Sample run for Oceano (resulting vpnd.conf)

- **local** :   172.16.97.78
- **remote** :   172.16.97.77
- **autoroute** :
- **keepalive** :   10
- **noanswer** :   3
- **keyfile** :   vpnd.key
- **pidfile** :   /var/run/vpnd-hawkmoon.pid
- **randomdev** :   /dev/urandom
- **mtu** :   1600
- **client** :   81.202.20.245 2010
- **server** :   81.202.117.88 2010
- **mode** :   server

## FAQ

### 8.1 Problems

#### 8.1.1 Gentoo (Thanks to Hawkmoon):

It seems that the script as provided within this package doesn't work fine with Gentoo, please, specify the full path to the vpnd.key file in each "master" configuration file, and be sure to edit "vpns" to point to your "vpnd" executable.

## Credits

### Copyright

Copyright (c) 2003 Pablo Iranzo Gómez (Pablo.Iranzo@uv.es) <http://Alufis35.uv.es/~iranzo/>

You're given permission to copy, distribute and/or modify this document under the terms of the GNU General Public License Version 2 or higher published by the Free Software Foundation

Please, if you use this program, email me to know where it gets to and if it's used.

### About

This document has been created using the LYX Editor and compiled with under Debian GNU/Linux, and then converted to the format you're viewing.

File translated from T~E~X by [T~T~H](http://hutchinson.belmont.ma.us/tth/), version 3.67.  On 9 Mar 2007, 21:50.
