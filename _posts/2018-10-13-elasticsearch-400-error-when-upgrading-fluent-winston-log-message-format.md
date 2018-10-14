---
layout: post
title: 'Elasticsearch 400 Error When Upgrading Fluent Winston Log Message Format'
date: '2018-10-13'
author: Simon
tags:
- elasticsearch
- caddyserver
- node
- js
- fluentd
---

Since it is now 2018, its time to upgrade nodejs logging from console logging to selfhosted

My current choice is Elasticsearch + fluent + [fluent-logger-node](https://github.com/fluent/fluent-logger-node) + [winston](https://github.com/winstonjs/winston).
When you are ready to implement something more complex to support custom kibana/grafana dashboards, you'll need to upgrade from
```javascript
logger.info('currently have 1 active user')
```
to
```javascript
logger.info({type:'active-users',count:1})
```

You'll probably see the following in your fluentd log:
```
2018-10-12 02:17:57 -0400 [warn]: #0 dump an error event: error_class=Fluent::Plugin::ElasticsearchErrorHandler::ElasticsearchError error="400 - Rejected by Elasticsearch" location=nil tag="memestream.club.8chan-worker" time=1539325072 record={"message"=>{"type"=>"active-users", "count"=>1}, "level"=>"info"}
```

To fix this, you will have to re-create the index so that Elasticsearch will pick up on that the message field is a complex object rather that a string.
