---
layout: post
title: release of blue-green-static-aws-edge 
date: '2022-01-05'
author: Simon
tags:
- aws
- cdk
- serverless
- basededge.dev
---

[REPO](https://github.com/BASED-EDGE/blue-green-static-aws-edge)


>This repo contains a sample reference AWS CDK stack for setting up a blue green deployed serverless distribution.

>A sample React javascript application is (async) chunked by webpack with a distinct buildId included in the publicPath. The cdk stack deploys the web assets to S3 (using the buildId as a the subfolder) as well as update the edge lambda to a new version with the latest buildId. AWS Code Deploy then slowly switches traffic b/w the old lambda and the new lambda. As users visit the page, they will be progressively more likely to see the new version over the old version until the deployment successfully completes. To reduce origin latency for users far away from us-east-1, a route53 latency based TXT record is used to redirect the s3Origin request to the closet s3 bucket (that contains all the same assets).

>If something were to go wrong with the latest assets, (ie: code bug), the code deployment would fail and revert to the old version. Since the javascript entry should never be cached, any users who were served the bad version will get the old version after reloading the page. The same rollback action could be manually performed if an issue was discovered after the deployment completed.

>The major down side with this approach is having to invoke a lambda every time a user loads the widget. This can lead to incurring Lambda costs, depending the level of traffic the app receives. These costs can be lower (or more operationally acceptable) than running comparable server(s) 24/7.

>Another issue is incurring addition costs from always having to fetch the index.js. This will incur a financial cost in terms of S3 GET requests as well as a performance cost of always having to fetch the asset from us-east-1 (the sample client app aggressively asynchronously loads everything in the index to minimize its size at build time and ensure that most of the app is cached at the edge by CloudFront). Using Route53 latency routing, the edge lambda was upgraded to redirect the origin request to the closest aws region + replicated bucket, to reduce distance based latency. Yet again, this introduces more (possible) line items to the AWS bill in terms of additional storage costs and DNS queries, but these should be pretty minor.

![](/assets/blue-green-static-aws-edge.drawio.png)

