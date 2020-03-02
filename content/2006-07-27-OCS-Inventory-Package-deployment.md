---
layout: post
title: OCS Inventory Package deployment
date: 2006-07-27T20:29:00Z
tags: hardware, linux, software, ocs, foss
comments: true
---

[TOC]

### Introduction

OCS Inventory is an excelent piece of GPL Software for getting info from hardware components, and software installed on computers running Windows or UNIX-like operating systems (there are also some unofficial clients for running on other platforms).

Since New Generation (OCS-NG), a new architecture was implemented: server were contacted using standard TCP/IP connection (Previous versions, used an MDB file to store information, and required a SMB share to inventory computers ), allowing remote computers to connect as well as providing a new web interface for computer administration, and inventory query.

Within new features, a new small client (about 64kb), was able to contact inventory server, and download from it the full set of required files (`OcsAgent.exe`) which was expanded to %SYSTEMDRIVE%ocs-ng, then executed, an inventory sent to server.

This approach had a little problem, if you had a small outgoing connection, serving a 700 Kb file was painful... but at least, despite some minor revision changes, machines were able to upgrade automatically (In many other times, you had to manually redeploy or force with the /DEPLOY:#VERNUMBER# the new deployment) when new version was deployed on the server.

With RC3, agent for installation uses near double that size, about 1.5 Mb, but the ability for after first installed, use external servers with a bigger upload bandwidth, eases installation of new versions in computers.

### Release Candidate 3, and 1.0

OCS-NG RC3 came with important architectural changes, including several major and minor improvements, being these the more important ones:

- Now the windows client works as a service (for the first time it includes a windows agent)
- RC3 includes a component for software/files deployment/distribution

The new tool is called package deployment. This feature it is managed using the also improved admin web interface.

OCS-NG could be setup on different machines hosting each service:

- An Inventory-receiving machine
- An Admin web interface
- A site with information about packages
- A site with package fragments for deployment

or, as I did in my setup, use a Debian Linux machine for doing the four tasks, but I plan to relay the fourth task to other machines, when packages are bigger than expected.

### Setting it up and running

I'll assume that you've running Apache, PHP, and were able to setup OCS using the bundled instructions, so you only have to enable new features for using package deployment.

First of all, we need SSL support in Apache.

Package deployment infrastructure, is too much powerfull, so it requiress SSL access to validate server before trying to download from it, so... we'll need some SSL certificates for use with our server.

I like [http://www.cacert.org](http://www.cacert.org/) services: they sign your certificates, and provide one certificate aiming to be used with many FOSS projects, because it's free instead of paid certificates like the ones from Thawte or Verisign.

### Getting SSL Certificates

First of all, we need to create a private key and a CSR (Certificate Signing Request) which we will send to CACERT for signing (please, note that if you don't have a domain name, will make it impossible to use OCS Package Deployment if your IP is also dynamic, so if that is your case (as was mine too), open an account at No-IP and create a URL-Redirector to your machine, you'll have to install an update client, but this will allow you to use certificates) it.

Having openssl installed, we will execute (please, double check that questions, specially CN exactly matches ServerName and "hostname", for it to work properly after) the following commands:

```bash
#!bash
openssl genrsa -out server.key 1024
openssl req -new -key server.key -out server.csr
```

First one, will create a private key called "server.key", second one, will create a CSR which we will paste at [https://www.cacert.org/account.php?id=10](https://www.cacert.org/account.php?id=10) to get our server certificate signed.

For being able to use [http://www.cacert.org](http://www.cacert.org/) services, we'll have to create an account and add a domain to it, this is verified sending an email to an account like webmaster, root or so, clicking on the supplied link, will entitle to work in representation of that domain.

After that, Cacert.org will show you a certificate for your server that you'll have to copy to a file called "server.crt".

Let's then download [CACERT's root certificate](http://www.cacert.org/certs/root.crt) to "cacert.pem"

#### Configuring apache for using that certificates

Next, we'll have to tell apache, to use this certificate for SSL support, in my case, I configured:

```apache
#!apache
/etc/apache2/conf.d/ssl:
SSLProtocol all
SSLOptions +StdEnvVars
SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
SSLCACertificateFile /etc/apache2/ssl/cacert.pem
SSLCertificateFile /etc/apache2/ssl/server.crt
SSLCertificateKeyFile /etc/apache2/ssl/server.key
```

So, I had to put server.crt, server.key and cacert.pem in `/etc/apache2/ssl/`

Next one, was to configure a new site that requires SSL to work:

```apache
#!apache
/etc/apache2/sites-enabled/001-default:
ServerName yourserver.no-ip.org
NameVirtualHost \*:443
ErrorLog /var/log/apache2/errssl.log
# Possible values include: debug, info, notice, warn, error, crit,
# alert, emerg.
LogLevel warn
CustomLog /var/log/apache2/ssl.log combined
ServerSignature On
DocumentRoot /var/www
SSLEngine on
SSLOptions +StdEnvVars
SetEnvIf User-Agent ".\*MSIE.\*" nokeepalive ssl-unclean-shutdown
```

Afterthat... we have to reload apache configuration and try to connect to [https://yourserver.no-ip.org](https://yourserver.no-ip.org/) to check if everything is ok.

Well, if this works, we had the first and harder step done ;)

### Creating a package

There are three types of packages: RUN, STORE and LAUNCH.

Each of them has different behaviour, one runs a command, the other downloads a file and stores it on a folder, and the other does a combined thing: downloads a file, unzips it, and then runs a command.

For Package creating, we must have write access to Apache's DocumentRoot/download folder, and after creation, copy contents of "/download" to "/", or as I did, gave write access to "/var/www", and create (`ln -s . download`) a symbolic link for download.

So... let's create a first package:

1. We must login into OCS Web interface, and select (first menu option on first yellow icon) package creation
1. We must assign a name for the package, Platform, Protocol and Priority (priority will allow us to decide package execution order in the client, the lower number, the higher priority)
1. If we're going to upload files, we must ZIP it BEFORE, so OCS will unzip on client machine, and then run commands
1. We choose an action, and then, a path (we can use system variables like %SYSTEMDRIVE%, %TEMP%, %USERPROFILE%,%PROGRAMFILES%, etc) to store the file, or command to run
1. We can choose if we want the user to be warned about package execution, and even to allow user to delay execution (useful for service pack deployments, etc)

Next step, will allow us to specify fragments (pieces in wich the package will be splitted for allowing better deployment, making use of redownloading for only failed fragments, etc), as well as checksum for data validity

Your package, will be created then on "/var/www/download/#pkgid#".

### Activating a package

Once a package has been defined, we have an "info" file, describing package actions, and package fragments, we can have them together or split it between different servers, and we will have to specify where is located each piece, before using it on our machines. That process is called "Activation".

When we select that option, we have to specify the pkgid, so we use the second menu entry in the package deployment icon, and we'll get a list of packages ready for activation, and then, we select "Activate" from the one we're interested in.

On package activation, we will be asked for two SERVERS (thanks to the development team, specially to Pascal who helped in determining that we require to specify server name, not URL) one with https (for downloading info file) and one with http for downloading fragments (if any).

After sending server names, OCS will check availability of "info" and fragment files (if any (On RUN packages, there is nothing to download prior to running the commands) and then, package will be activated and ready for next step.

#### Afecting a package

In this step, we can select a computer in the main view, or do a search using specific criteria, and as a result, apply a package on listed computers.

We can affect a package to several computers at once, just to one, and even, have different packages affect to the same computer....

OCS will connect, and execute actions defined in priority order...

#### How to get client side Package working

Packages from client side, are as easy to setup, as having a working OCS Agent Service installed and a file called cacert.pem, which we got from the SSL Creation step... having them in the OCS Agent folder, and a package affected to a computer, will make computer to download, and do the actions specified. ¿What are the pro's and con's of this method?

When installing OCSAgent, using: OCSAgentSetup.exe /S /SERVER:yourserver.no-ip.org, we have no cacert.pem file copied, so we must copy it by hand, or, as I did, use a scriptable install system whicho does this in one step.

I've used [NSIS](http://nsis.sourceforge.net/) to create a script for doing this:

First, we'll have to create a folder and put in it:

- OcsAgentSetup.exe
- cacert.pem
- NSIS Script
- service.ini (in my case, for accelerating first inventory creation)

service.ini like this:

```ini
#!ini
[OCS_SERVICE]
TTO_WAIT=10
PROLOG_FREQ=1
OLD_PROLOG_FREQ=1
Miscellaneous= /S /SERVER:yourserver.no-ip.org
```

And NSIS script with:

```batch
#!bat
; Script edited using HM NIS Edit Script Wizard.
; Creator Pablo Iranzo Gómez (Pablo.Iranzo@uv.es)
; Homepage: http://Alufis35.uv.es/~iranzo/
; License: http://creativecommons.org/licenses/by-sa/2.5/
; HM NIS Edit Wizard helper
defines
!define PRODUCT_NAME "OCS"
!define PRODUCT_VERSION "RC3"
!define PRODUCT_PUBLISHER "Pablo Iranzo Gomez (Pablo.Iranzo@uv.es)"
!define PRODUCT_WEB_SITE "http://Alufis35.uv.es/~iranzo/"
SetCompressor zlib
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "ocs-inst.exe"
InstallDir "$TEMP"
Icon "${NSISDIR}ContribGraphicsIconsmodern-install.ico"
SilentInstall silent
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""  Section "Principal" SEC01
SetOverwrite on
SetOutPath "$TEMP"
File "OcsAgentSetup.exe"
Exec "$TEMPOcsAgentSetup.exe /S /SERVER:yourserver.no-ip.org"
Exec "$PROGRAMFILESOCS Inventory AgentOCSService.exe -stop"
SetOutPath "$PROGRAMFILESOCS Inventory Agent"
File "cacert.pem"
File "service.ini"
Exec "$PROGRAMFILESOCS Inventory AgentOCSService.exe -start"
Exec "$PROGRAMFILESOCS Inventory AgentOCSInventory.exe /SERVER:yourserver.no-ip.org /DEBUG"
SectionEnd
Section -Post
SectionEnd`

```

This script, when compiled, will create a ocs-inst.exe file, with all
files needed packed in it, when executed, will:

1. silently run
1. extract OCSAgentSetup
1. install it using silent install
1. then, stop service
1. output cacert.pem certificate in OCS Service folder
1. replace service.ini for faster inventory, and then,
1. start service
1. Force DEBUG and hand-started inventory

This will leave us with a working OCS Agent Setup, with a valid certificate for autenticating against our deployment server, and ready for creating more packages.

I hope this document is good for you to test this excelent software.

Thanks (again) to the OCS Developing team (specially to Pascal Danek) for creating such a nice program, and helping in diagnosing problems found and setup procedures for correctly using it.

Thanks to Pablo Chamorro for reviewing this article too ;)

Have a look at [OCS Deployment Tips and tricks]({filename}2006-07-29-OCS-Deployment-Tips-and-tricks.md) to get ideas on how to use package deployment
