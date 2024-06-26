---
layout: post
title: cron-btsync (sample cdk arch)
date: '2024-06-26'
author: Simon
tags:
- nodejs
- cdk
- aws
---

[CODE](https://github.com/BASED-EDGE/cron-btsync)

![arch](/assets/cron-sync-arch.drawio.png)

# what
cron-btsync is an AWS CDK sample arch for setting up [resilio](https://www.resilio.com/) on an ec2 that is not directly exposed to the internet. Access to the webui for is only accessible by using SSM to set up a socks5 proxy to access the machine's localhost.

In order to save costs, the ec2 is only online for a few hours each week (controlled by a lambda invoking the ec2 api on a cloudwatch scheduled event)

# why

It is important to have backups of ones important files. Resoilio makes it very easy to keep a folder in sync across multiple devices (linux, windows, android, etc) while retaining ownership + control of the files. 
By running this on ec2, one can have an offsite backup incase multiple devices are taken out all at once.

# security features
1. no ssh access
2. no inbound connections allowed through the security group
3. no assigned elastic ip (every time the ec2 boots up, a new ip is assigned)
4. web ui is only accesible through localhost
5. access to the machine is only available through SSM (combined with proper AWS cred management, this is will expire any store creds automatically)
6. EBS is encrypted at rest using KMS
7. resilio is run in a docker container (isolating it from the host system....)
8. infrastructure is modeled in CDK, preventing the need for *click ops* and makes it a lot easier to deploy into its own AWS account. it also puts a lot of security outside of the control of the server itself and onto other AWS services.

# problems
1. AWS charges for outbound traffic, so one wants to avoid having other servers sync updates from this one
2. AWS has variable usage costs, which are hard to estimate up front
3. could this be handled cheaper by DigitalOcean ($4per month for 10GB disk + 500GB of traffic + 0.5GB ram)
4. AWS charges for EBS storage regardless of the status of the server
5. CDK (and cloudformation) can very easily destroy the instance and create a new one, if some parameters are changed after the intial deployment. note this is a great way to assert that your backups work

