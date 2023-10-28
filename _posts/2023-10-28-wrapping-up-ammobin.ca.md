---
layout: post
title: Wrapping Up ammobin.ca
date: '2023-10-28'
author: Simon
tags:
- ammobin.ca
---


Todo. Why shut down ammo in
6yrs?
https://github.com/ammobinDOTca/ammobin-client/commit/5b67ce6f4d71a36d2362b94927b2973c27da6153
started back in 2017


9ish bucks a month on AWS but it would fluctuate if doing a lot of deployments. Could have fixed this with GitHub actions
Nuxtv3 migration. 2> 3 was very involved. Lots of pkgs died. Or haven'tigrated. Couldn't migrate existing setup. So tried moving code into new starter. Just didn't work. Got caught up on something weird.
Just not worth it

Scrapes break. Don't want to fix it

Code is still around here https://github.com/ammobinDOTca/ammobin-client/releases/tag/LAST_LIVE_VERSION_OF_SITE

Some photos
started with single host + docker

ended up with https://github.com/ammobinDOTca/ammobin-cdk (issh)



User data. Deleted (unless AWS/cf has secrets logs)

Learnings
Nobody cares about tech. Open source code, never received any take up
AWS random costs. Lot more involved. Free beta account
Better than docker on droplet. Easier to deploy. Don't have to sign ine every so often to clean up machine and restart stuff


Pull some traffic numbers before deleting es

Also. Got me to self host at home
es -> https://ramsay.xyz/2022/05/09/simple-upstream-proxy-authentication-for-caddy.html

learned about seo
learned about challenges of selfhosted email

