---
layout: post
title: 'Easy ECS Login'
date: '2017-11-08'
author: Simon
tags:
- docker
- zsh
- ecs
---

just run
```
$(aws ecr get-login --no-include-email)
```

which will have the aws cli generate the docker login command and then zsh will run that command