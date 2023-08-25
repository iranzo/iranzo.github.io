---
layout: post
title: MiniDLNA SPEC & RPM
date: 2009-07-10T08:54:35.000Z
author: Pablo Iranzo Gómez
tags:
  - dlna
  - linux
  - rpm
  - spec
  - foss
categories:
  - FOSS
lastmod: 2023-08-25T09:48:46.928Z
---

MiniDLNA provides an OpenSource DLNA server software that can index and present specific folders on your computer to DLNA clients on your network.

Project at sourceforge is distributed as CVS code that you need to checkout and compile for it to work on your computer.

I've setup a spec file that will allow you to create an rpm that has been tested on Red Hat Enterprise Linux 5.3 machine x86 for easing adoption among users.

```spec
#!spec
%define dist .el%(rpm -q --queryformat='%{VERSION}' redhat-release 2> /dev/null | tr -cd '[:digit:]')
Summary: DLNA compatible server
Name: MiniDLNA
Version: 1.0.14
Release: 6
License: GPL
Group: System Environment/Utilities
Source: %{name}-%{version}.tar.gz
BuildRoot: /var/tmp/%{name}-buildroot
Vendor: MiniDLNA SF group https://sourceforge.net/projects/minidlna/
Packager: Pablo Iranzo Gómez (Pablo.Iranzo@uv.es)
BuildRequires: flac-devel, libvorbis-devel, libexif-devel, sqlite-devel, uuid-devel,ffmpeg-devel,libid3tag-devel, libjpeg-devel, e2fsprogs-devel, cvs
Requires: redhat-lsb

%description
MiniDLNA is a DLNA UPnP AV compatible server for being used by other DLNA capable devices

%prep
[ -d %{name} ] && rm -Rfv %{name}
mkdir %{name}
cd %{name}
cvs -q -d:pserver:anonymous@minidlna.cvs.sourceforge.net:/cvsroot/minidlna login
cvs -z3 -d:pserver:anonymous@minidlna.cvs.sourceforge.net:/cvsroot/minidlna co -P minidlna

%build
cd %{name}/minidlna
sh genconfig.sh
make

cat << EOF >> initscript
#!/bin/sh

# chkconfig: 345 99 10
# description: Startup/shutdown script for MiniDLNA daemon
#
# \$Id: minidlna.init.d.script,v 1.2 2009/07/02 00:33:15 jmaggard Exp \$
# MiniUPnP project
# author: Thomas Bernard
# website: http://miniupnp.free.fr/ or http://miniupnp.tuxfamily.org/
# Modified for RHEL Compatibility by Pablo Iranzo Gómez (Pablo.Iranzo@uv.es), http://Alufis35.uv.es/~iranzo/

MINIDLNA=/usr/sbin/minidlna
ARGS='-f /etc/minidlna.conf'

test -f \$MINIDLNA || exit 0

. /lib/lsb/init-functions

case "\$1" in
start)  MSG="Starting minidlna"
        start_daemon \$MINIDLNA $ARGS $LSBNAMES && log_success_msg \$MSG || log_failure_msg \$MSG
        ;;
stop)   MSG="Stopping minidlna"
        killproc \$MINIDLNA && log_success_msg \$MSG || log_failure_msg \$MSG
        ;;
restart|reload|force-reload)
        \$0 stop
        \$0 start
        ;;
*)      log_action_msg "Usage: /etc/init.d/minidlna {start|stop|restart|reload|force-reload}"
        exit 2
        ;;
esac
exit 0

EOF

%install
cd %{name}/minidlna

%{__install} -D -m0755 minidlna %{buildroot}/usr/sbin/minidlna
%{__install} -D -m0644 minidlna.conf %{buildroot}/etc/minidlna.conf
%{__install} -D -m0755 initscript %{buildroot}/etc/rc.d/init.d/minidlna

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%config /etc/minidlna.conf
/usr/sbin/minidlna
/etc/rc.d/init.d/minidlna

%post
chkconfig --add minidlna

%preun
service minidlna stop
chkconfig --del minidlna

%changelog
* Wed Jul 1 2009 Pablo Iranzo Gómez (Pablo.Iranzo@uv.es)
- Initial version
```

{{<enjoy>}}
