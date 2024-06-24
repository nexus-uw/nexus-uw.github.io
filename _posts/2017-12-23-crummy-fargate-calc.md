---
layout: post
title: 'Made a crummy aws cost calculator for Fargate using Preact'
date: '2017-12-23'
author: Simon
tags:
- preact
- fargate
- aws
---

![](/assets/ecs.png)![](/assets/preact.png)

Last month, Amazon released AWS Fargate for ECS which removed the need to manage the underling EC2s of an ECS cluster. Amazon charges by the second for this service based on vCPU + Memory, but I wanted to know the total hourly cost for this. So I made a cost calculator for it using [Preact](https://preactjs.com/) ("Fast 3kB alternative to React with the same ES6 API."). After selecting some ec2 configurations, it was clear to me that this costs more than the ec2 based solution (even ignoring spot instance pricing) BUT it is easier and has fewer things to worry about.

site: [https://nexus-uw.github.io/crappy-preact-fargate-calculator/](https://nexus-uw.github.io/crappy-preact-fargate-calculator/)

source: [https://github.com/nexus-uw/crappy-preact-fargate-calculator](https://github.com/nexus-uw/crappy-preact-fargate-calculator)
