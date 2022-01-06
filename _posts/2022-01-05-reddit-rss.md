---
layout: post
title: trashhalo/reddit-rss now support custom reddit alternative UIs 
date: '2022-01-05'
author: Simon
tags:
- rss
- reddit
- libredd
---

My [PR](https://github.com/trashhalo/reddit-rss/pull/36) was merged back in November 2021.

It allows redditt-rss to serve as an improved rss feed that links to [libredd.it](https://libredd.it/) (simple and lightweight reddit UI) or a selfhosted version.

Why not just use [teddit.net](https://teddit.net/) rss support?
1. They serve up the same limited reddit rss item (tinny thumbnail and no further content). trashhalo/reddit-rss will attempt to pull the actual content into the rss item.
2. I have found the teddit pages to take a while to load. libredd.it is much faster since it contains no JS and it does not attempt to save assets to disk.
3. I do not have any need to interact with reddit, so the js is completely unnecessary to me
