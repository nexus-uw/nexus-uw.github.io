---
layout: post
title: 'Cheap VPS Hot Tip'
date: '2018-09-18'
author: Simon
tags:
- vps
- docker
---


While [](https://lowendbox.com/) has lots of great deals, especially if you are willing and able to pay up front (ie: $39 per year for 4cpu + 6GB RAM [src](https://lowendbox.com/blog/sparkvps-4-offers-pure-ssd-vps-from-1-95-month-in-dallas-new-york/) compared to $5 per month for 1cpu + 1GB of RAM with [Digital Ocean](https://www.digitalocean.com/pricing/) )

It should be noted that these cheaper hosts usually use OpenVZ vps (as opposed to KVM). Docker will not run in such an environment since it requires 
([src](https://stackoverflow.com/a/29221590) and [src2](https://stackoverflow.com/a/35951482))
Ubuntu will allow you to install docker, but it will fail to start due to:

>"Your Linux kernel version 2.6.32-xxx is not supported for running docker. Please upgrade your kernel to 3.10.0 or newer."

