---
layout: post
title: Wrapping Up ammobin.ca
date: '2023-10-28'
author: Simon
tags:
- ammobin.ca
---


At the beging of October 2023, I chose to shutdown ammobin.ca after 6 years.

## Why
It costs me about $9USD a month and a bunch of maintaince time. The number of broken scrapes have been pilling up and I lack the interest in fixing them. 

Additionally, the Nuxt 2->3 migration has gotten stuck in the mud (with the code remaining on the bridge migration package). A bunch of plugins/middleware  is stuck on v2 without a clear migration plan (note: npm packages moving to scoped packages is a great way to make it very hard to know about version bumps). An attempt was made to re-write the front end in v3, but I lack the time or interest these days to take on that chunck of work

## How
frontend was switched out with a basic nuxt v3 app that redirects users to arsenalforce.ca ([src](https://github.com/ammobinDOTca/ammobin-client/commit/d37c12b3fd50dc3f4c38790f2b185ae2163b5444))

## What is happening with the old code + data

The client code is still around [here](https://github.com/ammobinDOTca/ammobin-client/releases/tag/LAST_LIVE_VERSION_OF_SITE). The backend code is still up on github, and the domain is valid for a few more years.

Any user data has been deleted from my datastore. Cloudflare + AWS may have their own user request logs that I cant access.




## History
Ammobin started with [single host + docker containers](https://github.com/ammobinDOTca/ammobin-compose) and ended up with a [AWS CDK Serverless setup](https://github.com/ammobinDOTca/ammobin-cdk) + Cloudflare Workers handling SSR for the frontend code.

## Learnings
- Nobody cares about tech. Open source code, never received any take up.
- AWS is a random costs. Costs flutuatch based on customer and dev usuage.
- AWS also lets you have a beta setup easily with serverless tech (since it can easily exist within the free tier)
- AWS is better than docker on DigitalOcean droplet. Easier to deploy. Don't have to ssh in every so often to clean up machine and restart stuff
- learned about seo (ammobin.ca was the top 1-2 results for ammo related searches for Canada)
- learned about challenges of selfhosted email (microsoft just refused to accept emails from my domain
  
