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

# mini-madeuce
![](/assets/mini-madeuce.jpg)

## what
mini madeuce is a selfhosted privacy focused url shortener

url [mini-madeuce.ramsay.xyz](https://mini-madeuce.ramsay.xyz/?ref=blog)

onion [madeucev3nrsti4nthzqt22dw2n57lseca3735yjhxddevl3zhtg3mad.onion](http://madeucev3nrsti4nthzqt22dw2n57lseca3735yjhxddevl3zhtg3mad.onion)

github [nexus-uw/mini-madeuce](https://github.com/nexus-uw/mini-madeuce)

## why
sharing mokin token notes is a real pain if one has to manually type in the url (~150 characters long).

## how or things that make is special to the end user
1. selfhostable (opensource + verifiable)
2. no js (and strict csp) greatly reduces the attack vector and ability to sneak in something else
3. link expiry (both time and usage). ensures that shorted url will go away
4. no logs or tracking (since not a business)

### sample work flow
Create password with massive-pass, store it using mokintoken, take the encrypted url and shorten it using mini-madeuce. Then manually enter the shorten url on the separate computer so that the password can be copy pasted

### threats mini-madeuce protects against
1. Shorted url is discovered in a data leak (ie: email hacked, droped usb stick).
  if after usage limit (default 1, max 10) or expiry (default 1, max 720 hours)
  shortened url will already been deleted from the service's db, service does not indicate if the url ever even existed.
2. Shorted url is intercepted before it expires/used up. If created with the 1 use count, when the intended user of the url visits the short url, it will not work for them. If they are smart, they will know that the url has been intercepted and whatever they were using for it has been compromised. ideally they would switch communication channels.
3. Prevents writting down passwords in order to manually copy over to a new machine. If combined with mokin-token, long passwords can be shared with a new computer/smart phone by first encrypting with mokin-token, and then the long url is shortened by mini-madeuce. The user can then manually entered on the new machine, the full password can copypasted.
