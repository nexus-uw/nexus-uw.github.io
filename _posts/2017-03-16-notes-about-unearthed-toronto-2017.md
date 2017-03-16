---
layout: post
title: 'Notes About Unearthed Toronto 2017'
date: '2017-03-16'
author: Simon
tags:
  hackathon
  barrick
  unearthed
  toronto hackathon
  snapfix.io
  vue.js
  rails
  docker
---
![](/assets/unearthed-logo-300.png) ![](/assets/snapfix-logo.png)

Two weeks ago I participated in the [Unearthed Toronto hackathon](https://unearthed.solutions/hackathons/unearthed-toronto-2017/). It was sponsored by Barick Gold who also provided the problems and data sets.


[letaylor622](https://github.com/letaylor622), [Cameron2920](https://github.com/Cameron2920), and I where able to put together a working prototype of an pre-emptive inventory system for a haul truck mechanic shop. We were able to take a service history of truck, and calculate the average up time between service visits each 'component' of the truck would require ([nexus-uw/report-history-analysis](https://github.com/nexus-uw/report-history-analysis)). Taking these results, the system was able to tell the mechanics/inventory mangers how much parts inventory they required to service the trucks when they were expected to require work. The expected inventory demand was then displayed alongside the actual inventory levels so that they could see how well they would be able to meet demand. Our solution had a responsive [web app](https://github.com/nexus-uw/uneathed-webapp) built with vue.js, [rails backend](https://github.com/Cameron2920/unearthed-pepperoni), and a Postgres DB (everything is deployed using docker and live at [https://snapfix.io](https://snapfix.io)).

In the end, we did not win.

### Lessons Learned
- You dont have to actually build something, vaporware is acceptable if the idea is bold and exciting. (Some of the teams comprised of data scientists had much bolder solutions to the problems presented).
- A concise and focused pitch is key.
- Nobody cares about the tools you used, only how it looks on the projector.
- If you already have a team, avoid accepting randos. Best to keep things simple.

