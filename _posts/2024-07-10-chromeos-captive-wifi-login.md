---
layout: post
title: working around wifi captive portal issues with chromeOS 
date: '2024-07-10'
author: Simon
---


Today I was unable to connect to the Starbucks wifi using my Chromebook. Whenever the browser would try to load the [connectivitycheck](
https://connectivitycheck.gstatic.com/generate_204) to trigger the redirection to the login page, it would fail to connect. 
This has to happen over http or else you will get SSL cert issues because the wifi network is unable to cleanly interupt HTTPS request.

Looking at my browser settings I noticed, I had turned on "Always use secure connections". This setting causes the browser to only make HTTPS requests (and it was upgrading the connectivty check to HTTPS before it was sent over the wire).

![chrome https only flag](/assets/Screenshot 2024-07-10 10.57.02.png)

Turning this off, allowed Starbucks to redirect me to their login. Once the login was completed, flipping it back on did not affect my browsing.

## note
- I wonder if Chrome should whitelist connectivitycheck.gstatic.com from their HTTPS only mode? They do own both ends of this flow.
- the same approach should also work for other open wifi networks (ie: Airports, Hotels)
