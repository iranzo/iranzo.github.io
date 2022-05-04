---
layout: post
title: OCS Deployment Tips and tricks
date: 2006-07-29T20:13:00.000Z
tags:
  - OCS
  - Linux
  - FOSS
modified: 2022-05-04T13:15:43.573Z
categories:
  - FOSS
---

Prior to using the following info for creating own-made packages, let's test if everything is working fine.

I've created a NSIS script that writes into registry in a key called `HKLMSOFTWAREOCS` and puts a key named "cert" with value `creilla`.

If we create a package with action "LAUNCH", and attach the `regcert.zip` with command to execute `regcert.exe`, all clients with functional package deployment, will add that key to registry, so we can check, using OCS registry query function for a key named "cert" into: `HKLM` `SOFTWAREOCS`.

After some time, affected and with working software deployment (Read [OCS Inventory Package deployment]({{< ref "2006-07-27-OCS-Inventory-Package-deployment.en.md">}}) to learn how to set up it properly), we could know in which ones it's working and in which ones it doesn't work, just doing a search for computers with a special value in that registry key. (I've also uploaded the precompiled version I use for your testing purposes).

### Software

```raw
  ------------------------------------------------------------------- ----------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  **Software**                                                        Command switches                                                  **Result**
  [OCS Inventory](http://ocsinventory.sf.net/)                        /S /SERVER:serverip                                               Installs new OCS version on top of older one, this is only recommended if package deployment was setup successfully, if not, use NSIS script referred at OCS Inventory Package Deployment
  [VNC](http://www.realvnc.com/)                                      /SP- /VERYSILENT                                                  Installs VNC without any user intervention
  [PowerOff](http://users.pandora.be/jbosman/poweroff/poweroff.htm)   Just copy to desired folder                                       Allows to shutdown, reboot hibernate, etc remotely or from command line
  [EICAR](http://www.eicar.org/)                                      Copy and run from any folder                                      This file is detected by antivirus as a virus, but it isn't harmful (read [http://www.eicar.org](http://www.eicar.org/)), if execution fails... target computer has a working antivirus engine running
  [Firefox](http://www.mozilla.com/)                                  -ms -ira                                                          Installs Mozilla Firefox silently (with 1.5 it show uncompressing dialog, but with 2b2 it's totally invisible)
  [Java](http://www.java.com/)                                        /S /v/qn" WEBSTARTICON=0 REBOOT=Suppress MOZILLA=1 IEXPLORER=1"   Installs Java Runtime Environment (tested on 1.5.0.0.6) silently, totally invisible
  [Acrobat Reader](http://www.adobe.com/)                             msiexec.exe /i acrobat.msi /qb-!                                  Silent install, must first uncompress installation and copy extracted files to a folder, zip them, and upload to OCS (you can extract Acrobat components doing: AdbeRdr80.exe -nos_s -nos_ne -nos_oC:temp)
  [Flash Player](http://www.adobe.com/)                               msiexec /i fp9.msi /qn                                            Silent install using windows installer interface (it's ok for other programs distributed in msi files
  ------------------------------------------------------------------- ----------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
```

### Registry

```raw
  Hive   Path                                                                             Value          Utility
  ------ -------------------------------------------------------------------------------- -------------- ---------------------------------------------------------------------------
  HKLM   SOFTWAREMicrosoftWindowsCurrentVersionRun                                *             Know which programs are executed at startup
  HKCU   SOFTWAREMicrosoftWindowsCurrentVersionRun                                *             Know which programs are executed at user login
  HKLM   SOFTWARENetwork AssociatesTVDShared ComponentsVirusScan Engine4.0.xx   szVirDefDate   Know Mcafee Virus Definitions date
  HKLM   SoftwareSymantecSharedDefs                                                   *             Shows different norton products definitions
  HKLM   SoftwareMicrosoftWindowsCurrentVersion                                     ProductKey     Windows 9x Install key
  HKLM   SoftwareMicrosoftWindowsCurrentVersionRunServices                        *             Services in the machine
  HKLM   SoftwareMicrosoftWindowsCurrentVersionRunServices                        *             Windows 9x Services
  HKLM   SoftwareOCS                                                                    cert           Allows us to check if package deployment is working using regcert example
```

### Packages

```raw
  Action   File   Command line                                                 Description
  -------- ------ ------------------------------------------------------------ -----------------------------------------------------------------------------------------------
  RUN             "%PROGRAMFILES%RealVNCVNC4winvnc4.exe" -connect HOST   Launches a new VNC client to HOST, allowing to watch Desktop as HOST initiated the connection
  RUN             netsh firewall add portopening TCP 5900 VNC                  Opens 5900 port on TCP in Windows Firewall (XP SP2) (for using with VNC)
```

Please, feel free to contribute with your Registry Keys or command line commands to improve this guide.

Using win-get (an apt-get clone for Win32), you can use [this big list](http://windows-get.sourceforge.net/listapps.php) of supported applications for installation doing `win-get sinstall APPNAME`
