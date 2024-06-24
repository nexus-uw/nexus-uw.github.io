---
layout: post
title: mokintoken is now go
date: '2024-02-19'
author: Simon
tags:
- go
- mokintoken
---

Over Christmas, I converted mokintoken from [PHP to Go](https://github.com/nexus-uw/mokintoken/pull/21). This migration did not require any front end work (nice).

# why
1. I knew little of PHP and the docker container was 700MB+ and filled with dependencies I knew little of
2. Go is kinda hot today
3. While I dont know much about Go, I was able to code the server in a single file with only 2 basic dependencies (uuid + sqlite)
4. Docker container is down to 14mb
