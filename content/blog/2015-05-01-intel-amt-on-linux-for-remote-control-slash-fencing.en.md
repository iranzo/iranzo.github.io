---
layout: post
title: Intel AMT on Linux for remote control/fencing
date: "2015-05-01 11:35:14 +0200"
tags:
  - Linux
  - fencing
  - management
  - foss
modified: "2022-01-16T21:11:30.907Z"
---

Hi,

Some time ago, and after discussing with a colleague, I had a look on Intel's [AMT](http://en.wikipedia.org/wiki/Intel_Active_Management_Technology), and this week I
did a demo for another colleague as a cheap-replacement for having power fencing capabilities on commodity hardware.

AMT provides a server-like Out of band management like iLO, iDRAC, RSB etc and it's included in i3 with vPro processors/chipsets of some equipment.

I did the test on a Lenovo X200/201 system I had as old laptop.

The steps used for configuring it, require to:

- first enable the support in the BIOS, usually named 'Intel AMT' or 'Intel Active Management Technology'.
- After this step it was possible to use the command to enter the special AMT firmware `Intel(R) Management Engine` which on this laptop is enabled with `CTRL-P`.
- If this is the first time you enable it, you'll require to change the default `admin` password to something secure, usually mixed upper-lower case, symbol and numbers.
  - For this example we'll be using `Qwer123$` as password.
- Explore the settings, enable it and validate network settings.
  - I've enabled DHCP on both LAN and Wireless for IPv4 and IPv6, and enabled KVM redirection
- Once finished, save changes and exit from firmware screen and let the system boot.

From another host, you can perform the remaining configuration steps, from now on, the 'target' system will be intercepting packets sent to specific port via the network cards and redirect to AMT firmware instead of going to target host. This is something important to note, the packets are only intercepting when coming from **OUTSIDE** the host so we'll use a second computer to access it.

You can use a browser pointing to target system's IP at port `16992`, for example: <http://target:16992>

From that web interface and once logging with `admin` and the password set `Qwer123$` we can continue doing some configuration, like the power states to control (for example, this laptop could be remotely powered when it was with the charger connected even if laptop was powered off).

Now, for doing the 'command-line' part, we will need to install one package on our system and rum some scripts.

```bash
# First we'll install amtterm wsmancli

dnf -y install amtterm wsmancli

# This will provide the two commands we'll later use, wsman for configuration and amttool for power control

# We need to define the host to use and password as well as the password we'll use for console redirection (via VNC)

AMT_PASSWORD='Qwer123$'
AMT_HOST=target
VNC_PASSWORD='Qwer123$'

# we can define those vars (specially AMT_PASSWORD) in our .profile or .bash_profile in order to avoid typing them everytime

# set the vnc password (must be 8 characters MAX)
wsman put http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h ${AMT_HOST} -P 16992 -u admin -p ${AMT_PASSWORD} -k RFBPassword=${VNC_PASSWORD}

# enable KVM redirection to port 5900 (this will also intercept 5900 port for console redirection, so make it sure you'll not need it later)
wsman put http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h ${AMT_HOST} -P 16992 -u admin -p ${AMT_PASSWORD} -k Is5900PortEnabled=true

# disable opt-in policy (do not ask user for console access)
wsman put http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h ${AMT_HOST} -P 16992 -u admin -p ${AMT_PASSWORD} -k OptInPolicy=false

# disable session timeout (do not timeout sessions)
wsman put http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h ${AMT_HOST} -P 16992 -u admin -p ${AMT_PASSWORD} -k SessionTimeout=0

# enable KVM (enable keyboard/video/monitor redirection)
wsman invoke -a RequestStateChange http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_KVMRedirectionSAP -h ${AMT_HOST} -P 16992 -u admin -p ${AMT_PASSWORD} -k RequestedState=2

# OPTIONAL: view settings (validate all the settings)
wsman get http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h ${AMT_HOST} -P 16992 -u admin -p ${AMT_PASSWORD}

```

After this step, we should be able to use `vinagre target` to access the KVM redirection and remotely control our system.

For example, to control power of host you can use:

```bash
# Check host status:
amttool $AMT_HOST info

# Power up a powered-off host:
amttool $AMT_HOST powerup

# Power down a powered-on host:
amttool $AMT_HOST powerdown
```

Check `man amttool` for other commands like `reset`, `powercycle`.

IMPORTANT: note that some power state changes can only be performed based on previous status, you can check with `info` the available ones and current status of system.

As a bonus, there's a RFE[^1] for requesting this tool to be incorporated as power fencing mechanism in fence-agents once 'amtterm' is included in RHEL, in the meantime it's already available in Fedora, and when it comes to RHEL, **hopefully** could also be used as fence agent for Clusters and RHEV.

Enjoy!

[^1]: Request for Enhancement: a bugzilla request oriented not to fix a bug, but to incorporate new functionality/software into a product.
