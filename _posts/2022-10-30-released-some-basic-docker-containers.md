---
layout: post
title: released some basic Caddy Docker containers
date: '2022-10-30'
author: Simon
tags:
- caddy
- docker
---


# created caddy-do and caddy-gandi

both of these containers are plain caddy containers with the DigitalOcean and Gandi DNS plugins already installed.

# why?
### enabled auto build using github actions
keeps the base image up to date (since these ones dont need be changed)

### allows for SSL at home (behind ones NAT)
I have found it handy to assign real public DNS names to my internal devices (ie: example.at.home.ramsay.xyz -> 10.0.0.2). 

Enabling HSTS on ramsay.xyz (with subdomains) has then caused my browser to refuse to connect to http only servers at home.

Since Caddy usually issues certs by hosting a validation file on your server, it needs to be publicly accessible. But with DNS validation, the server can be isolated on a private network (like ones NAT at home)

# Buy why ssl home?
1. protect against local network snooping (ie: random cheap iot device, not so friendly guest)
2. can enforce HTTPS only CSP for self hosted site
3. allows one to enroll their personal domain in [HSTS preload list](https://hstspreload.org/) (since it requires HSTS header to includeSudDomains)

# links
## github
[caddy-do](https://github.com/nexus-uw/caddy-do)

[caddy-gandi](https://github.com/nexus-uw/caddy-gandi)

## containers
```ghcr.io/nexus-uw/caddy-do```

```ghcr.io/nexus-uw/caddy-gandi```
