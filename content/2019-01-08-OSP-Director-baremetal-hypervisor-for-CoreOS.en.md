---
author: Pablo Iranzo Gómez
title: OSP Director baremetal hypervisor for CoreOS
tags: OpenStack, TripleO, baremetal, CoreOS, foss, Linux
layout: post
date: 2019-01-08 17:30:36 +0100
comments: true
category: tech
description:
lang: en
---

[TOC]

## OSP Director

OSP Director (or upstream TripleO) is a life-cycle manager for OpenStack based on the idea of using 'OpenStack' to deploy 'OpenStack'.

To do so, it creates a management 'Undercloud', that is configured and prepared for later deploying an 'overcloud' which is the one that will later run the workloads.

TripleO/Director, also automates the inspection of hosts and tagging to the roles they will perform later in the 'overcloud' setup, such as 'controller', 'compute', 'storage', or even mixed roles via `composable-roles` support.

## Baremetal Nova instances

From OSP Director point of view, the baremetal servers that will be used for computes, are represented like 'OpenStack instances' using a special flavor and are controlled via IPMI mechanisms to control boot sequence, power status, etc via 'ironic' component.

## OpenShift CNV

OpenShift, can run on top of baremetal or on top of nova instances, and it's one of the common scenarios to deploy OpenShift on top of OpenStack.

In this case, for CNV, we also want to benefit from increased performance of running Virtual Machines as Kubernetes workloads.

In order to setup a new host to be used as baremetal 'instance' to run Kubernetes node on top we do need to follow TripleO/Director approach, via adding a new host to ironic managed hosts list:

- Create a new host definition (if reusing the original one, and importing it, will cause many of the discovered attributes via introspection to be lost):

!!! hint

    Bear in mind that proper MAC address of the interface connected to the 'provisioning' network must be specified as it's used by PXE to boot the right image.

```json
{
  "nodes": [
    {
      "pm_password": "$YOURIPMIPASS",
      "name": "blade-ocp-node-1",
      "pm_type": "pxe_ipmitool",
      "pm_addr": "10.19.0.89",
      "mac": ["18:DB:F2:8C:D5:FA"],
      "arch": "x86_64",
      "pm_user": "root",
      "disk": "40",
      "cpu": "2",
      "memory": "4096"
    }
  ]
}
```

- Then, import the new node into ironic database:

```sh
    openstack baremetal import ~/new_node.json
```

- Next, set the node as manageable and perform `instrospection` to validate the capabilities of the hardware:

```sh
    openstack baremetal node manage blade-ocp-node-1
    openstack overcloud node introspect blade-ocp-node-1 --provide
```

- After this above, the node should have rebooted, started the introspection and reported back the values to Director node.
- Now, let's set some specific values to match our 'baremetal' flavour (nova flavor-show baremetal):

```sh
    ironic node-update $NODEID add properties/capabilities='profile:baremetal,boot_option:local'
    ironic node-update $NODEID add properties/resources='CUSTOM_BAREMETAL:1'
```

- As we plan to deploy RHCOS on the baremetal node, let's prepare some steps:

```sh
    wget https://$HOSTNAME/$PATH_TO_THE_LATEST_FILE
    gunzip rhcos-4.0.6844-openstack.qcow2.gz
    openstack image create --file $DOWNLOADEDFILE.qcow2 rhcos-image
```

- Create a `config.ign` filename with your SSH key for 'core' user and CA's:

```yaml
{
  "ignition":
    {
      "config": {},
      "security":
        {
          "tls":
            {
              "certificateAuthorities":
                [
                  {
                    "source": "data:text/plain;charset=utf-8;base64,LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDVENDQWZHZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFtTVJJd0VBWURWUVFMRXdsdmNHVnUKYzJocFpuUXhFREFPQmdOVkJBTVRCM0p2YjNRdFkyRXdIaGNOTVRnd09USTJNVGswTURVNFdoY05Namd3T1RJegpNVGswTURVNFdqQW1NUkl3RUFZRFZRUUxFd2x2Y0dWdWMyaHBablF4RURBT0JnTlZCQU1UQjNKdmIzUXRZMkV3CmdnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURtZVlYbEZMZ0ZjU1Jxak51NE0vSnIKL2JwNlQzbmRlZGlqU3Q1Ti9DbnlTblhMVlExR3pYMngzUGZ0aHhXKzYxRFlGUE5xZzNPUlJKbURLUGJHbU5LSQovTUVuZkgrZVlrekZXY3BxQVhQMXlzbEpVWUVLNWhMSlJ6cCtjSWxmQ09zSW9nSGpwRlZlRkdVRWtzUzR5cXY2CjJsYWgvRWdURkhFZkFmUlhTc1VCN0owcWRWdExsWGJJc0thdzJvSVJ2V1g4M0x1RzhmSnpBalZlUVVBQldpT1EKOHZwY2NteUd6eXc1STNmMkdZMWxkZnVNSXI5TjNtSUFhMDluMUNqTE1Eem9hbjViZ0NzWHJyYWlhWFFWbEMwZgovMGw4eXIyczM4VmUrZmhrckw4K0xKVHpxaDdvb3JtYWR5eFJPRUR2VFZhWlFPSi90MzMyNm9DSHRaS1JkWW0xCkFnTUJBQUdqUWpCQU1BNEdBMVVkRHdFQi93UUVBd0lDcERBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWQKRGdRV0JCUzREQm43eTR6YmFXaWdjcjFFK0tjeUsvRnhGakFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBbllzVQpQTkpaVGNiMTZ1QVRzNEpwUGpoMGJPMG9MSmttSlVhOTJIRXVaVlhCd2FpbEVmdjBNdmpONUlFTnFoa3VXQllTCkl3RHdKTmd3cS80QU5xQUNlNG5uaWpUeUlvY3ExVEFkcnNldGd3Y3RDV3Bra3o5RTBPUVY4V29ucEV0TTZ2VEMKQlZKWjhITGFjY05HT21taXBDbEIvT0dncnRqU0t3SC9HTEtQcmp4MStWVmdaWnRuU0xVTk5OaDFTZ1oyeTh2OApZNlFVZUJYUmhTWkNvUXJadlEvYldQWXE2ZlprMFNCVDJnUm9QaGxXVys2aVhQVlhBUkVDU1lYbDQ2WnNKNnJ1CnJTZnBydEZBbDVFY0NSNDc4U2FYT0VxS0dlZEJEblZreXZQY29pSkdvT3VKNVljUWZ2WGNGQ0NYSE93T3c0dXQKWEhrN3dEZFdJVEUvV0cweWhRPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
                    "verification": {},
                  },
                ],
            },
        },
      "timeouts": {},
      "version": "2.2.0",
    },
  "networkd": {},
  "passwd":
    {
      "users":
        [
          {
            "name": "core",
            "sshAuthorizedKeys":
              [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8k6sAkPLWIUwov0YPLi3ex7WAw35MGZhXyC7Seyu9703wO436NBHOtRGFwl8gTbMR9k/WG0tPbNS42H06Zpi8vCB+ITftqBCWjlKOgOQKnvEiC73JhgounQPvjhj2r/JEvrPQ8QThHnBPLjFk5dGH9AORanEcNr9BBG/YXCgdcXAgZL9pQ+jhoy0JRnKhGpQLGzyMeuUYOfxcivXHKZFZzZ4fluSskx1Wm+Zw1Tzbhr/rTTvrlkQVmzxMlOjN/k02/CdEDjDG5G8Qb2QKsIqnZZy05snnfeN0B2u8uEhcfvW1IvKrRT/BXYlU3E7Rz7cboJlJ54eiKRlZXCQtXDYCfdJwHudaNtL5w31F4xOObdpCv3ANQb6Ravr0LG91liKMjaYCGNYkrP7S3v7D7gkpDyjNn7DYqgwCk2D/oU/NeuMZCB6PsBB2R2rXexq0EIgFw/bwabASQghCkV3JkOj5kIRvrQfFb3jZJDMEoELvAWLhGg08qvHg1leV3xm8+coobXiGqdmoGPCPATGb/4Evl1DR3mSrLYh88TAInCCDzivBSr+SLOl2BSpbwmJ0suIS3AIT04KeHJMpicOsOZE8SuDrngHTlCasZaoMF9ny6GiK3/jX7VJuTmYjtG7unZ5C7U7tT0jdMUcWOYezEhvLc1EmZtDSCYycxAC9s6oKdw== Pablo.Iranzo@gmail.com",
              ],
          },
        ],
    },
  "storage": {},
  "systemd": {},
}
```

- Last step is to deploy the baremetal server with the configuration and flavor:

```sh
    openstack server create --nic net-id=<ctlplane_ID> --config-drive true --user-data config.ign --flavor baremetal --image <rhcos-image-id> blade-ocp-node-1
```

If everything went thru, a `nova list` will show the instance as `spawning` and after some more time, the server will be ready and accessible via `ssh core@$SERVERIP`.

If it doesn't, ensure to setup nova in 'debug' mode for Undercloud, restart the services and try again, usually, the 'no valid hosts found' error is the most generic one but will give you some 'tips' on which filter ruled servers out.
