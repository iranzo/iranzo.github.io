---
author: Pablo Iranzo Gómez
title: Ubiquiti UniFi for WiFi network
tags:
  - UniFi
  - Linux
  - Ubiquiti
  - ASUS
  - AC-LR
  - NanoHD
  - controller
  - USG
  - US-8
  - AX92U
layout: post
date: 2021-01-01 00:00:00 +0200
category: tech
lang: en
modified: 2022-03-23T10:00:47.222Z
---

## Introduction

During the pandemic I wanted to work a bit on the wireless system at home, the router provided by the ISP was having already issues that resulted in WiFi devices not connecting and only new devices were able to report 'AP full' message when the connection failed.

First I started testing the ASUS devices like the [AX92U](https://www.amazon.es/dp/B07SCBMMS8?tag=redken-21) which had WiFi 6 support. My flat is not that big, but as I had some issues with 2.4Ghz devices like smart power plugs, I decided to go for a second unit of the same router and test the `AI-Mesh` that was announced by ASUS as the best way to extend coverage.

Unfortunately, that meant several things:

- WiFi 6 (available only in one of the two 5Ghz channels) was used for linking both AX92 routers, so clients couldn't use it (I only had one laptop that supported it and got an [Intel AX200 WiFi card](https://s.click.aliexpress.com/e/_bXaDkKt) for an older laptop to test it)
- That still left one 2.4Ghz channel and a 5Ghz channel to provide service to clients, while the WiFi 6 was used for the connection between both APs to provide connectivity

The outcome was not good for having spent 400 EUR in WiFi equipment for a 90 m² flat and still have more disconnection issues from devices... so all came back to where it came from.

For some months I was still checking reviews and struggling on how to improve it, it was not like thousand of WiFi devices, but still wanted network to work fine, and the result was that even if the Router was configured to allow more wireless clients, it was not allowing all of them to connect, so when I tried to reconnect a WiFi plug or an old phone that was sitting in a drawer, there was no way to get it working.

## Ubiquiti UniFi

Later in the year, after speaking with a colleague, he mentioned that he went with [UniFi AC-LR (Long Range)](https://www.amazon.es/dp/B016K5A06C?tag=redken-21)

{{<warning title="Check the parameter values">}}
Read before you start!!!

- It's not for noobs, requires either using a very simple approach using 'standalone mode' or buying dedicated hardware for running the 'Controller' or running a container on a [Raspberry Pi](https://www.amazon.es/dp/B0899VXM8F?tag=redken-21) or on your NAS/Computer
- Configuration is not as easy as other routers
  {{</warning>}}

In exchange you get:

- Complete monitoring via their tool
- Configuration is kept at controller, you can add/remove devices and they will get 'provisioned' with the configuration automatically.
- APs can 'join' over WiFi to generate a network more capable of dealing with failures.
- APs use a Power Injector to get both data and power, so ideal for placing in the ceiling and just driving a RJ45 wire there.

In general my experience was really smooth:

- [AC-LR](https://www.amazon.es/dp/B016K5A06C?tag=redken-21) solved my connectivity problems for all the WiFi devices (2.4 and 5Ghz)
- Devices roamed from one AP to another transparently (only one was wired to my ISP router and the other was 'linking' via WiFi)
- Container installation via `linuxserver/unifi-controller` container was great:
  ```sh
  podman create   --name=UniFi-controller   -e PUID=1000   -e PGID=1000   -e MEM_LIMIT=1024M   -p 3478:3478/udp   -p 10001:10001/udp   -p 8080:8080   -p 8443:8443   -p 1900:1900/udp   -p 8843:8843    -p 8880:8880    -p 6789:6789    -p 5514:5514    -v /root/data/UniFi:/config:Z   --restart unless-stopped linuxserver/UniFi-controller
  ```
  - Upgrades for it are also easy: first remove the existing container, then pull a new image and create a new container pointing to the same data folders. All from my Fedora NAS

# The final setup

After some time, still under the evaluation, I experienced sometimes some issues with the `AC-LR AP`, it was performing fine, but when streaming from the one near my living room from TV (that connected via wireless to the one connected to the router), sometimes [Prime Video](https://www.primevideo.com/?tag=redken-21) had some hiccups. With my experience with the ASUS in the past, I decided to return the devices before it was too late and go for the [UniFi NanoHD](https://www.amazon.es/dp/B07FFNTLJD?tag=redken-21).

This device, in comparison, had better throughput in 5Ghz mode (with a bit higher cost than `AC-LR`), but smaller antennas (`LR` stands for Long-Range).

As I was happy with the UniFi setup, I also got some other hardware:

- [US-Gateway](https://www.amazon.es/dp/B00LV8YZLK?tag=redken-21&psc=1) to be directly connected to my router
- [US-8 ports switch](https://www.amazon.es/dp/B01N362YPG?tag=redken-21&psc=1) to replace a underused 24 ports one
- 2 [NanoHD AP](https://www.amazon.es/dp/B07FFNTLJD?tag=redken-21)

They were connected in the following way:

{% graphviz
dot {
digraph connected {
// title
labelloc="t";
label="Network Setup";
"ISP Router" -> "UniFi Gateway" [color=red,dir="both",shape=square]
"UniFi Gateway" -> "UniFi 8 switch" [color=red,dir="both",shape=square]
"UniFi 8 switch" -> "NanoHD (office)" [color=red,shape=circle,dir="both"]
"NanoHD (office)" -> "NanoHD (living room)" [color=red,shape=circle,dir="both"]
"UniFi 8 switch" -> "NAS" [color=red,dir="both",shape=square]
"UniFi 8 switch" -> "Laptop" [color=red,dir="both",shape=square]
"UniFi 8 switch" -> "NUC" [color=red,dir="both",shape=square]

    }

}
%}

The Controller software is running as a container in the `NAS` system and manages the full infrastructure.

I'm attaching here some of the pictures of the User Interface.
{{<gallery>}}
{{<figure src="https://i.imgur.com/gPGruVNt.jpg" link="https://i.imgur.com/gPGruVN.jpg.jpg" alt="" >}}
{{<figure src="https://i.imgur.com/c7LDMAyt.jpg" link="https://i.imgur.com/c7LDMAy.jpg.jpg" alt="" >}}
{{<figure src="https://i.imgur.com/tgBgeU9t.jpg" link="https://i.imgur.com/tgBgeU9.jpg.jpg" alt="" >}}

{{<figure src="https://i.imgur.com/9OxA63Ht.jpg" link="https://i.imgur.com/9OxA63H.jpg.jpg" alt="" >}}
{{<figure src="https://i.imgur.com/5wpQ9vAt.jpg" link="https://i.imgur.com/5wpQ9vA.jpg.jpg" alt="" >}}
{{<figure src="https://i.imgur.com/tnjGtCHt.jpg" link="https://i.imgur.com/tnjGtCH.jpg.jpg" alt="" >}}

{{<figure src="https://i.imgur.com/iHhiNwAt.jpg" link="https://i.imgur.com/iHhiNwA.jpg.jpg" alt="" >}}
{{</gallery>}}

{{< load-photoswipe >}}

Some of the features I like:

- the ability to setup a guest portal than can even use 'tickets', so that you can limit internet access by day
- you can add/remove devices and they get the configuration from the controller
- when using the USG, you get extra features like VLAN for isolating network traffic, DHCP server, etc
- devices can get an alias (instead of mac or given name) from the User Interface, reserve IP address, etc.
- Devices are running Linux and you can connect to them via SSH

Hope you like it!
