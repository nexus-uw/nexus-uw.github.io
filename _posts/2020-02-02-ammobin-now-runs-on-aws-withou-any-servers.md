---
layout: post
title: 'Ammobin now runs on AWS using only severless technology thanks to AWS-CDK'
date: '2020-02-02'
author: Simon
tags:
- ammobin.ca
- aws
- aws-cdk
- serverless
---

# Background
Since it's launch in 2017, [ammobin.ca](https://ammobin.ca) has been successfully running on a single Digital Ocean machine (2 GB +	2 vCPUs) using docker compose ([ammobinDOTca/ammobin-compose](https://github.com/ammobinDOTca/ammobin-compose)) + crontab. It currently costs about ~$17 USD per month. There have been very few issues with this setup outside of infrequent space issues + os updates bricking the server (requiring manual restarts)

![digital ocean architecture as of december 2019](/assets/digital ocean docker setup.png)

# What is AWS CDK and why should one migrate to it?
>The AWS Cloud Development Kit (AWS CDK) is an open source software development framework to model and provision your cloud application resources using familiar programming languages.

>Provisioning cloud applications can be a challenging process that requires you to perform manual actions, write custom scripts, maintain templates, or learn domain-specific languages. AWS CDK uses the familiarity and expressive power of programming languages for modeling your applications. It provides you with high-level components that preconfigure cloud resources with proven defaults, so you can build cloud applications without needing to be an expert. AWS CDK provisions your resources in a safe, repeatable manner through AWS CloudFormation. It also enables you to compose and share your own custom components that incorporate your organization's requirements, helping you start new projects faster.
[src](https://aws.amazon.com/cdk/)

I chose to use CDK over plain CloudFormation because it a new and novel alternative to static YAML templates and manually zip + uploading assets. From my previous experiences with CloudFormation, I found that the templates were difficult to debug as well as discover what the structure of the documents were (especially around object references). To add to this, many of the restrictions and validations can only be checked when the stack tries to create/update resources. This can add significant time to the deploy/debug cycle especially around resources dependant on CloudFront distributions.

My past few months of developing with CDK have been pretty great. Using VS Code as my IDE greatly helps with auto completing, automatic imports, and clicking through to the source JSDOCs. Additionally the static type-checking is able to continuously run in the background allowing for errors to be surfaced before manually building + deploying. Even then, transpiling + running the typescript stacks will provide additional run time checks + validations before uploading the resulting CloudFormation template(s) to AWS to perform their changes.


# Repo
[https://github.com/ammobinDOTca/ammobin-cdk](https://github.com/ammobinDOTca/ammobin-cdk)

# AWS diagram
![aws ammobin stack](/assets/aws ammobin.ca cdk.png)

![aws ammobin pipeline](/assets/aws regions and stages.png)


not pictured: [github actions re-generating the static assets every day](https://github.com/ammobinDOTca/s3-bucket/blob/master/.github/workflows/main.yml)


# cost numbers
ammobin.ca has been running on AWS since January 2020. During this time it has been able to mostly stay within the free tier. The majority of the bill is related to DynamoDB write requests ([did adjust refresh frequency in mid January](https://github.com/ammobinDOTca/ammobin-api/commit/79e762dd766cb04f55b68cdf8915a35fbd27ffed) ), Code Build time (partially due to figuring out Pipelines + IAM) ,and KMS for storing the elastic search password.

All in, January cost $15.07 USD (after taxes). February is forecasted by AWS to cost $14.82, but I expect it to come a bit under that.


# issues/challenges discovered

## ca-central-1
ca-central-1 does not appear to be a tier 1 region since a lot of the shiniest services have not been deployed there.

Somethings I discovered not available (at time of writing) in ca-central-1
- http gateway (cheaper + simpler version of api gateway. have not breached the free tier yet, but still want to use it)
- CloudWatch canaries (every service needs lots of canary traffic)
(not relevant to the current stack but would be considered for an ecs/eks alternative)
- a1 ec2 (ARM)
- spot instances for Fargate (why not, this sounds super cool)

## CloudFront us-east-1 restrictions

CloudFront is a global AWS service and can be created from any region but everything it uses (ie: acm certs, lambdas) have to be us-east-1. I fail to understand why CloudFront/CloudFormation lets people create their distributions outside of us-east-1. It only serves to complicate things when developers want to extend their distribution from a stack outside of us-east-1 and they must either create static references in code or use a bunch of custom resources (with lots of custom logic) to handle the deployment.

I found it much easier to only create the distribution in us-east-1 so that all of its related resources can cleanly exist in the same stack. As for how to connect it back to the rest of ammobin in ca-central-1, custom (internal) CNAMES was really handy since they could be easily shared between the stacks using a common constants typescript file.

## s3 costs
It was easy to blow through the PUT request free tier with a daily re-upload of ```nuxt generate``` within a few days. This forced a re-architecting of the stack to make use of the free tier of github pages + actions.

cdk has an easy asset zip + upload process for lambda code. By not optimizing the asset packages being uploaded, the 5GB free storage limit was easily reached after a month of development. Reducing the lambda bundle size + removing old zips solved this issue.

A clean up lambda or a s3 bucket policy will have to be developed later to remove the old assets.


## lambda size constraints
[ref](https://docs.aws.amazon.com/lambda/latest/dg/limits.html)
As easy as CDK makes it, one cannot blindly zip up an entire repo with all of its node_modules, raw typescript files,  dev dependencies, and multiple built js files.
Webpack is the best build tool for solving this. By compressing all of the actual dependencies of a lambda into a single file (and not forgetting to exclude aws-sdk),
the deployment package can be reduced to a single file (measured in KB). This has the additional benefit of helping with the dreaded cold boot time (was able to save 800ms on the graphql lambda

## log costs and exporting

I found the AWS documentation around log exporting difficult to understand and it was not directed at my use case. Kinesis is sold as the tool for analyzing + exporting logs but it does not scale low enough ammobin. As it currently stands, Kinesis has a base cost of 25$ per month (ie: does not scale to 0) which is way higher than the current digital ocean budget.

While lambdas could export their logs directly to my elasticsearch, I chose to forgo this option in order to let the lambda complete and respond quicker.

In the end I went with having a separate lambda be triggered by CloudWatch log events. It appears that AWS does not suggest this option because manually configuring this through the CloudWatch console displays a warning about run away costs
![lambda subscription cost warning message](/assets/lambda subscription cost warning message.png )


Additionally, I was unable to find clear documentation regarding how the lambda is invoked. From the above warning, I interpreted it to mean that a lambda would be invoked **per log line**. This was not the case. CloudWatch performs some sort of batching (unsure how the batch size is determined) and delivers the log lines to the lambda as an encoded string. decoding these and sending them to elasticsearch was rather easy.
[log exporter code](https://github.com/ammobinDOTca/ammobin-cdk/blob/master/lambdas/log-exporter/elasticsearch.ts)


But still required (simple) custom CDK construct ([ref](https://github.com/ammobinDOTca/ammobin-cdk/blob/master/lib/CloudWatchScheduleEvent.ts))


(side note: I am very happy that CDK has native support for setting the log expiry of Lambda logs directly within the lambda construct)

## ec2 (or lightsail)
While this is not an issue with AWS, I chose to not use ec2 (or LightSail). Ammobin could have been *trivially* migrated to a single host (reserved instance...), this would have skipped the more interesting world of serverless tech. Additionally Ammobin is too small to make use of auto scaling or justify the cost of a load balancer (and thus unable to use spot instances)

# Open Issues
## cold starts + lambda response times
After all of the above, cold starts are still a noticeable thing. This is partially due to low traffic. Partially due to absence of caching (dex + reserved capacity is too expensive) cold starts are still a thing.

CloudFront is not designed to cache POST requests (aka getItemsListing).
alternatives
1. put the lambda in a VPC + spin up a tiny Elastic Cache instance (todo cost). haven't investigated tradeoff between vpc cold start and dynamo
2. dex caching  (todo: cost)
3. migrated graphql POST requests to GET -> implemented this in late January ([code](https://github.com/ammobinDOTca/ammobin-client/commit/70779298dfd430476b2a26960f116375ea3ac388))


## serverside rendering
While nuxt is really great for local development and production servers, I have found it lacking in lambda support. following the default set up + <nuxt serverless pkg> did not scale to ammobin's use. typescript + apollo added significant bloat that blew through the 250MB code size. Creating a custom build step that pre-build the server/client and included only the required production dependencies, did get past this blocker but the performance and resource requirements was unacceptable (1GB ram and 2.5s response time).

[next.js serverless build](https://nextjs.org/blog/next-8#serverless-nextjs) -> It would be great to see something similar to nuxt...

## ecs costs
hidden cost -> %25 per month for application load balancer (less for simpler load balancers). Would be nice if AWS included monthly costs on their price sheets (maybe just an estimate...)
did consider new spot instance for Fargate, but they are not available yet for ca-central-1

## API Gateway vs HTTP Gateway
HTTP gateway still in preview and not in ca-central-1, so ammobin has to continue to use apigateway with next to no configuration (3 paths total, with the basic lambda integration). luckily they are still within the free tier so no issue

# remaining work

## User-Agent
CloudFront will only pass client's Headers to the origin if they are configured to be used in caching. <todo: ref aws doc>. This is ok for the GET api requests, it would be nice to include it in the POST requests. StackOverflow's top suggestion is to configure two edge lambdas to move the headers around,

Might work around this by only referring to the manually inserted user-agent in sendBeacon requests as a proxy for user agent -> has the advantage of only caring about people who *use* the site


# Conclusions
Working with aws + cdk was a great experience but Digital Ocean is still way easier and less stressful. Not having to worry about hidden and unexpected costs when there is clear upfront monthly cost (billed hourly but prices are also displayed by the month) . able to closely mirror real production env

All this being said, Ammobin will continue to be run on AWS for increased stability and a slight cost saving.

