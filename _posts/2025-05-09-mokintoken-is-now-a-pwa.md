---
layout: post
title: MokinToken is now available as a PWA
date: '2025-05-09'
author: Simon
---

https://mokintoken.ramsay.xyz is now available as a PWA. The main feature that one enables by installing the PWA is that it adds mokintoken as a share_target. Users can use the Android share functionality to send text directly to the app and have it uploaded as an encrypted note.
Currently, the note is configured allow 1 viewing and a 4hr TTL.

Internally, a service worker is installed to intercept the POST share request, encrypt it locally, send the encrypted blob to the server, and then redirect the user to resulting 'note saved' page with the url + QR code.
[CODE](https://github.com/nexus-uw/mokintoken/blob/master/resources/js/service-worker.js)

![pwa icon](/assets/1721474985945.jpeg)

Aside, this feature informed me of 2 things. First, to intercept any fetch requests, the service worker needs to be installed at the root scope (ie '/'). Second, enabling docker cache is pretty important for building Go applications inside docker containers on GitHub Actions ([ref](https://github.com/nexus-uw/mokintoken/blob/master/.github/workflows/image.yml#L24-L42))
