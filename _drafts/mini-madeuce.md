---
layout: post
title: 'Mini Madeuce - a selfhosted url shortener'
date: 'xxxx-xx-xx'
author: Simon
tags:
- selfhosted
- golang
- docker
- privacy
---

why
sharing moken token notes is a real pain if one has to manually type in the url (~150 characters long)


url

onion

github

things that make is special to the end user
1. selfhostable (opensource + verifiable)
2. no js (and strict csp) greatly reduces the attack vector and ability to sneak in something else
3. link expiry (both time and usage). ensures that shorted url will go away
4. no logs or tracking (since not a business)


https://ramsay.xyz/2020/03/27/mokintoken-released.html

https://ramsay.xyz/2021/04/17/massive-pass.html


sample work flow
 create password with massive-pass, store it using mokintoken, take the encrypted url and shorten it using mini-madeuce. then manually enter the shorten url on the separate computer so that the password can be copy pasted

threats this protects against
1. shorted url is discovered in a data leak .
if after usage limit (default 1, max 10) or expiry (default 1, max 720 hours)
shortened url has already been deleted from the service's db. service does not indicate if the url ever even existed
2. shorted url is intercepted before it expires/used up
if created with the 1 use count, when the intended user of the url visits the short url, it will not work for them
if they are smart, they will know that the url has been intercepted and whatever they were using for it has been compromised. ideally they would switch communication channels
3. can use this to share encrypted notes stored with mokin-token to separate devices for things sending super long password(s) from a password manager to new (or temp) device if a direct transfer link is not possible