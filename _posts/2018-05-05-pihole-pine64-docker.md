---
layout: post
title: 'How to (kinda) install pihole on a pine64-jessie using docker'
date: '2018-05-05'
author: Simon
tags:
- pihole
- pine64
- docker
- add blockers
---

More of half thoughts and documentation of what I did to get pihole running in docker on my pine64 at home. This is not intended to be a complete or through guide. Please google or duckduckgo for the full process of setting this up. Note: as of May 5, 2018, the docker image does not have dns logging enabled and I have been unable to turn it on manually.

# some defs
- [Pine64](https://www.pine64.org/?product=pine-a64-lts): "The Pine A64 is an index card sized 64-bit single board computer. It can perform like your desktop or portable PC with browsing the Internet, playing games, watching video, and execute programs like spreadsheets and word-processing. The Pine A64 board can also play ultra high definition 4Kx2K video."
- [Docker](https://docs.docker.com/): "Docker provides a way to run applications securely isolated in a container, packaged with all its dependencies and libraries."
- [pihole](https://pi-hole.net/): "A black hole for Internet advertisements"

###  install docker
1. add some pre-reqs
 ```bash
  sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
  ```
2. add docker signing key ```curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -```  ([src](https://docs.docker.com/install/linux/docker-ce/debian/#set-up-the-repository))
3. add _deb https://download.docker.com/linux/debian jessie stable_ to _/etc/apt/sources.list.d/docker.list_
4. actually install docker ``` sudo apt-get update && sudo apt-get install docker-ce```

###  pull image + run
1. create some configs

2. create docker service to run in background with name = pihole and configs located in current directory
 ```bash
  IP_LOOKUP="$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')"  # May not work for VPN / tun0
  IP="${IP:-$IP_LOOKUP}"  # use $IP, if set, otherwise IP_LOOKUP
  DOCKER_CONFIGS="$(pwd)"  # Default of directory you run this from, update to where ever.
```
```bash
  docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp -p 80:80 \
    -v "${DOCKER_CONFIGS}/pihole/:/etc/pihole/" \
    -v "${DOCKER_CONFIGS}/dnsmasq.d/:/etc/dnsmasq.d/" \
    -e ServerIP="${IP:-$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')}" \
    --restart=always \
    diginc/pi-hole-multiarch:debian_aarch64
```
note: must use **diginc/pi-hole-multiarch:debian_aarch64**, other ones will not run on the pine64
3. to have pihole start on boot, run ```crontab -e``` and add the line _@reboot docker start pihole_
