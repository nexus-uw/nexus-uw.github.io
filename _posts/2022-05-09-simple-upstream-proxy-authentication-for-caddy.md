---
layout: post
title: simple upstream proxy authentication for caddy
date: '2022-05-09'
author: Simon
tags:
- caddy
- security
---

# A VERY Simple upstream proxy authentication for Caddy

Moving selfhosted services from a VPS to a machine at home can be handy for saving on VPS resources (CPU, RAM, and disk space) but exposes the risk of leaking the home IP address. To protect ones home UP address, the VPS can be used as a downstream proxy to handle incoming traffic. Having the upstream server require a special header to be set by the downstream server, helps to make sure that only the downstream sever can connect to the upstream. This is quicker and easier to deploy than a VPN.

## Code
(Assuming that both the upstream and downstream servers are running Caddy)

[DOC](https://caddyserver.com/docs/caddyfile/matchers#header)
### Entrypoint Caddyfile
```
https://selfhostedservice.ramsay.xyz {
  reverse_proxy https://selfhostedservice.rabaranks.duckdns.org {
    header_up +Random some_random_string
  }
}

```
### Upstream Caddyfile
```
https://selfhostedservice.rabaranks.duckdns.org {
  @basicauth{
      header Random some_random_string
  }
  reverse_proxy @basicauth selfhostedservice:8080
}
```

## Limitations of this setup
- it does not easily scale beyond single key
- security by obscurity (ie: unexpected header used)
- long lived credentials (api key is being passed over the wire and rotation requires manual edits on both the upstream and downstream servers)
- since using non-standard http header, it could easily show up in server logs
- creds are stored in plain text within caddyfile
- upstream server will still accept direct requests + responds with blank response (indicating that something is running there + the domain name is valid)


## (Better) Alternatives
- [Tailscale](https://tailscale.com/)
- [Cloudflare Tunnels](https://www.cloudflare.com/en-ca/products/tunnel/)
- [VPN](https://github.com/awesome-foss/awesome-sysadmin#vpn)