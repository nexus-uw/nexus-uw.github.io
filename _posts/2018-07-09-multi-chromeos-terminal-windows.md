---
layout: post
title: 'How to open multi instances of secure shell app in Chrome OS'
date: '2018-07-09'
author: Simon
tags:
- Chrome OS
- ssh
- secure shell app
---

Chrome OS is a pretty neat operating system that imposes some interesting restrictions on the user (next to no local storage, mostly webapps, limited chrome apps, software must be installed through the Chrome Web Store). Luckily Google has
developed a [nice ssh
client](https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo?utm_source=chrome-app-launcher-search)
which I have become accustomed to while bumping around my local network.

But Chrome OS likes to keep one instance of apps running at a time. When a user already has a session open and clicks the
app icon, Chrome takes the user to open session. While this is handy for most apps, most people want to open multiple
sessions.

Luckily, I discovered (no way the first person, but trying to put this all in one place) a couple of ways to get around
this.


open new tab type “ssh” in navbar + tab + enter new instance of chrome “secure shell app”

OR

duplicate an existing ssh tab

OR

paste "chrome-extension://pnhechapfaindjhompbnflcldabbghjo/html/nassh.html" into a new tab

