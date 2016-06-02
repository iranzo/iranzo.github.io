---
layout: post
title: SSH, stunnel and a proxy -  double stunnel bypass
date: 2006-11-01T17:47:00Z
tags: linux, network
---

I'm working for a "very concerned about security" firm, that makes mandatory using VPN for accessing their network, and internal services:

-  IMAPS
-  SMTP
-  Intranet
-  Forums
-  Online training, etc

As it should, we provided services for a client, also very concerned about security, thus not allowing internet access despite of using two squid proxys with a network appliance filtering protocols, scripts, viruses and malware. They only allow FTP, HTTP and HTTPS.

What to do when you need to access your business services from within the client network?

### Ingredients 

-  ssh
-  an intermediate computer outside both networks (at home, for example...)
-  a machine which you can reach by ssh on your business
-  a squid server

### Extras 

-  [SSH Proxy Command](http://zippo.taiyo.co.jp/~gotoh/ssh/connect.html) by Shun-ichi GOTO

### Preparation 

First of all, we need to be able to exit from our client network, and the only way is to use HTTP, HTTPS or FTP... and if we use HTTP packet filtering, would block access, so we only have the SSL choice, as it is cyphered, and doesn't tolerate "Man-in-the-middle" attacks, and allows us to get internet traffic trought it.

### SSH Proxy command 

SSH Proxy command, is a excelent piece of code, distributed in C in only one file that we will get compiled with `gcc command.c -o connect`

With "connect" we will get a connection, for example ssh trought squid.  The way to configure it is just editing `.ssh/config` file and make it look kind of sort like this:

~~~
Host home.com
    KeepAlive yes
    ProxyCommand connect -H proxy.client.com:3128 %h %p
~~~

Now, when we execute `ssh home.com 22` a SSH connection will be made using the squid proxy.

First problem arises, finding that we have a very smart client, and blocks every connection getting trought squid ending in privileged-ports despite of ftp(21),http(80) or https(443)...

As we have full-control of our computer at home, we can make SSH listen to 22 and 2222 adding a line `Listen 2222` in `/etc/ssh/sshd_config`.

Well, after this step, we have exterior connectivity, and we can make use of a good utility that SSH provides us: "tunnels" that will pass inside the ssh connection, so let's use one text editor and begin modifyng .ssh/configto add something like:

~~~
Host casa.com
    KeepAlive yes
    ProxyCommand connect -H proxy.cliente.com:3128 %h 2222
    LocalForward 10993 127.0.0.1:10993
    LocalForward 1025 127.0.0.1:1025
    LocalForward 2225 127.0.0.1:2225
    compression yes`
~~~

In this way, after establishing connection (trought the proxy) we will also establish three tunnels that will link 10993, 1025 and 2225 ports with 10993, 1025 and 2225 from our house's computer.

This step could have been avoided connecting directly to our business computer (but as they are also very concerned about security (filtering, one time passwords (s/key), etc), they aren't willing to change is security policies listening on extra port)...

We will need to repeat this configuration at home, this time, without using SSH Proxy Command, as we have full internet access from home.

Let's edit `.ssh/config` from our house's machine, and we will add the following configuration:

~~~
Host business.com
    compression yes
    KeepAlive yes
    LocalForward 10993 business.com:993
    LocalForward 1025 business.com:25
    LocalForward 2225 business.com:3128
~~~

Now, if we connect using ssh from home, we will redirect another set of ports...

Launch script:

~~~
#!bash 
echo "Launching ssh tunnel"
ssh -fNC home.com # Runs connection trought http proxy, and exits, leaving ssh
echo "Starting ssh tunnels from home"
ssh -t home.com ssh -ftNC business.com #redirects tty, allowing us to enter one-time-password, and because it will not forks to background, process will appear as blocked at this point for a while
~~~

killtunnel script:

~~~
#!bash 
#(Requires improvements like identifying started processes for not killing other not opened by "launch" script.
echo "Script connected, press enter for disconnecting"
read  
echo "Killing remote session" ssh -f casa.com
killall -9 ssh
echo "Killing local session" 
killall -9 ssh`
~~~

Now, we can run at our command line `lanzar` and automatically all tunnels will be created for accessing IMAPS, SMTP and our business internal Proxy all by just using 10993, 1025 & 2225 of our local machine (all within a only-web internet access network ;) )

Special thanks to a colleague, JMP for original script for using ssh tunnels that I adapted for this manual.

