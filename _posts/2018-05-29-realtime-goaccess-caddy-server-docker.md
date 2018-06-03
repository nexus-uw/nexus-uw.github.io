---
layout: post
author: Simon
title: 'How I set up real-time Caddy log monitoring using GoAccess, all within docker-compose'
date: '2018-05-29'
tags:
- docker
- Caddy server
- GoAccess real-time
- docker-compose
---

After running [goaccess](https://goaccess.io/) through a cron job to generate the report every 15mins, I decided it was time to live in future and take advantage of goaccess realtime log processing. Since I prefer to reduce the number of install steps + configuration tasks, I went with adding goaccess to my [docker compose](https://docs.docker.com/compose/overview/) config.

## Code

Using this [goaccess config](https://github.com/ammobinDOTca/ammobin-compose/blob/master/goaccess/data/goaccess.conf)
```
log-format COMBINED
addr 0.0.0.0
origin https://stats.ammobin.ca
exclude-ip 172.16.0.0-172.31.255.255 #docker ips
```

With the following [caddy snippet](https://github.com/ammobinDOTca/ammobin-compose/blob/master/Caddyfile)

```
...

stats.ammobin.ca {
  tls some@email.com
  root  /www/goaccess
  gzip
  push
  basicauth / USER PASSWORD
  log
}

stats.ammobin.ca:7890 {
 log
 tls some@email.com
 proxy / goaccess:7890 {
   websocket
 }
}

```

connected the 2 using this [docker-compose](https://github.com/ammobinDOTca/ammobin-compose/blob/master/docker-compose.yml)

```yml
version: '3'
services:
  caddy:
    image: abiosoft/caddy
    volumes:
      - ./.caddy:/root/.caddy
      - ./Caddyfile:/etc/Caddyfile
      - ./caddy-logs:/var/log/caddy
      - ./goaccess/html:/www/goaccess
      - ./caddy-srv/:/srv
    ports:
      - 80:80
      - 443:443
      - 7890:7890
    command: --agree --conf  "/etc/Caddyfile"
  ...
  goaccess:
    image: allinurl/goaccess
    volumes:
      - ./goaccess/data:/srv/data
      - ./goaccess/html:/srv/report
      - ./caddy-logs:/srv/logs
    entrypoint: goaccess --no-global-config --config-file=/srv/data/goaccess.conf --ws-url=wss://stats.ammobin.ca --output=/srv/report/index.html --log-file=/srv/logs/ammobin.log --real-time-html
```

# now real time log reporting is enabled...
