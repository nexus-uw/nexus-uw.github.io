---
layout: post
title: 'How to Secure Elasticsearch With Caddyserver'
date: '2018-10-13'
author: Simon
tags:
- elasticsearch
- caddyserver
- docker
- fluentd
---

By default, Elasticsearch does not support authentication since user management and such are part of the proprietary X-pack addon (gotta find some cash to cover that IPO).

BUT we can work around this with Caddyserver. For this example, docker-compose can set up our Elasticsearch box:

```yml
version: '3.2'
services:  
  caddy:
      image: abiosoft/caddy
      links:
        - elasticsearch
      volumes:
        - ./Caddyfile:/etc/Caddyfile
      ports:
        - 80:80
        - 443:443
      command: --agree --conf  "/etc/Caddyfile"
  elasticsearch:
      image: docker.elastic.co/elasticsearch/elasticsearch:6.4.0
```


The caddy file will provide basic HTTP Auth and HTTPS to protect our elasticsearch container with the following caddyfile

```
https://somepublicurl.com {
  tls some@email.com
  proxy / elasticsearch:9200
  basicauth / the_sun_god_emperor wow_this_would_make_a_great_password_dont_tell_anyone
}
```

Then to send some data from a remote machine, the sample fluentd config file shows the config needed:
```

<match something.**>
  @type elasticsearch
  host somepublicurl.com
  port 443
  user the_sun_god_emperor
  password wow_this_would_make_a_great_password_dont_tell_anyone
  scheme https
  ssl_version TLSv1_2
  include_timestamp true
  index_name some_index_name
</match>
```

note: the following fluentd log message
```
 [warn]: #0 Could not connect Elasticsearch. Assuming Elasticsearch 5.
```

is an understatement. This should be considered a **fatal**. It means your config is crap.
Adding with_transporter_log true to your < match > section will explain why it is not working.


This setup can be pretty handy for self hosting Elasticsearch at home b/c Elasticsearch wants some heavy (for personal + seflhosted use) requirements for RAM + disk. by keeping this stuff at home, you don't have to spent ~$40 per month for an equivalent VPS.
