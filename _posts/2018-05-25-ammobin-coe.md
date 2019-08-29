---
layout: post
title: 'Correction Of Error (COE) for ammobin.ca downtime'
date: '2018-05-25'
author: Simon
tags:
- COE
- correction of error
- downtime
- ammobin.ca
---
# Correction Of Error (COE) for ammobin.ca downtime
site was down for most of friday

## Cause: droplet disconnects from public ip
- not able to ssh or ping
- going through digital ocean console, able to access terminal, no ethX visible at all, even after many restarts
- reach out to support at 9am pst. receive response 5pm pst. did not fix issue

## Fix: created new droplet
1. git clone ammobin-compose
2. filled out secrets (.env file)
3. docker-compose up -d
4. switch over dns record
new droplet starts getting traffic immediately

## Lessons Learned:
- ability to quickly spin up fresh machine is easy with docker compose (able to bring site back with 10mins of work)
- external + automated backups are a good thing (lost dashboards + stats + cron jobs)
- dont wait around on support people to fix things if able to just recreate
- some cloud init scripts to set up machine for me (oh-my-zsh, docker, docker-compose) would be nice
- publicly exposed status page at [https://status.ammobin.ca](https://status.ammobin.ca)

note: COE is an amazon thing that is well described here: [https://blog.mischel.com/2018/01/24/responding-to-errors-at-amazon/](https://blog.mischel.com/2018/01/24/responding-to-errors-at-amazon/)


