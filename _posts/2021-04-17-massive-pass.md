---
layout: post
title: 'MASSIVE PASS: an unspecial password generator'
date: '2021-04-17'
author: Simon
tags:
- massive
- pass
- password
- js
- sirv
---

created a selfhostable password generator, massive pass

[CODE](https://github.com/nexus-uw/massive-pass)

[live version](https://massive-pass.ramsay.xyz/)

[TOR](http://massiveeeati5xv7sszovagrkamzdtshv4sg4rzpbg6n2btwkv2f2lqd.onion/)

### things that make is special
1. selfhostable (see docker container in README)
2. enforces + displays the [script integrity SHA](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) which allows anyone to verify that script being served is the same script as committed to the github repo (note: this requires a production npm install to ensure that only the exact npm packages are installed). think of it as something of a reproducible build

### why
- strong passwords are good
- simplified site is easier to audit its resources (ie no ad networks)
- selfhostable so that one can run it themselves
- OSS so that the code can be reviewed
