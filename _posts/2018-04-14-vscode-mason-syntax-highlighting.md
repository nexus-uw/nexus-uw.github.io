---
layout: post
title: 'How to enable syntax highlighting in VSCode for Mason files'
date: '2018-04-14'
author: Simon
tags:
- mason
- perl
- vscode
---

By default [VSCode](https://code.visualstudio.com/) does not detect that [Mason](http://www.masonhq.com/) files are perl files. Adding the following to your user preferences will do a pretty good job of adding some colour to your Mason development:

```json
  "files.associations": {
    "*.mas": "html",
    "autohandler": "perl",
    "*.mi": "perl"
  }
```

