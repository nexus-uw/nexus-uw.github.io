---
layout: post
title: 'Ammobin now runs on AWS using only severless technology thanks to AWS-CDK'
date: '2019-11-24'
author: Simon
tags:
- ammobin.ca
- aws
- aws-cdk
---

# Background
Since it's launch in 2017, [ammobin.ca](https://ammobin.ca) has been successfully running on a single Digital Ocean machine (2 GB +	2 vCPUs) using docker compose ([ammobinDOTca/ammobin-compose](https://github.com/ammobinDOTca/ammobin-compose)) + crontab. It currently costs about ~$17 USD per month. There have been very few issues with this setup outside of infrequent space issues + os updates bricking the server (requiring manual restarts)


# What is AWS CDK and why should one migrate to it?
>The AWS Cloud Development Kit (AWS CDK) is an open source software development framework to model and provision your cloud application resources using familiar programming languages.

>Provisioning cloud applications can be a challenging process that requires you to perform manual actions, write custom scripts, maintain templates, or learn domain-specific languages. AWS CDK uses the familiarity and expressive power of programming languages for modeling your applications. It provides you with high-level components that preconfigure cloud resources with proven defaults, so you can build cloud applications without needing to be an expert. AWS CDK provisions your resources in a safe, repeatable manner through AWS CloudFormation. It also enables you to compose and share your own custom components that incorporate your organization's requirements, helping you start new projects faster.
[src](https://aws.amazon.com/cdk/)

I chose to use CDK because it a new novel alternative to static YAML templates and manually zip + uploading assets. From my previous experiences with Cloudformation, I found that the templates were difficult to debug as well as discover what the structure of the documents were (especially around object references).

My past few months of developing with CDK have been pretty great. Using VS Code as my IDE greatly helps with auto completing, automatic imports, and clicking through to the source JSDOCs. Additionally the static type-checking is able to continuously run in the background allowing for errors to be surfaced before manually building + deploying


# Repo
[https://github.com/ammobinDOTca/ammobin-cdk](https://github.com/ammobinDOTca/ammobin-cdk)

# aws diagram
![](/assets/aws ammobin.ca cdk.png)
not pictured: github actions re-generating the static assets every day (https://github.com/ammobinDOTca/s3-bucket/blob/master/.github/workflows/main.yml)


# cost numbers
TODO:  need to run for a month or so

# issues/challenges discovered

## cloudfront us-east-1 restrictions

cloudfront is global and can be created from any region but everything it uses (ie: acm certs, lambdas) have to be us-east-1

unsure why they let people do it anyways

easier to isolate it and its resources to own stack in us-east-1

custom cnames is really handy for origins

(note custom internal CNAMES)

## kms costs
unexpected cost


## s3 costs
easy to blow through PUT request free tier with a daily re-upload of nuxt generate within a few days


## lambda size constraints
cant just zip og node modules
webpack is really handy here, able to reduce from 80mb zip to sub 1 mb
this affects the cold start time significantly

## log costs and exporting
todo: figure out costs
- cloudwatch prints out a cost warning about the lambda cost
- kensis costs ~$25 per month for 1 shard
- documentation does not make it clear that lambda is not invoked per log line, but instead invoked in batches and the log lines are zipped up (TODO: logger code link)

## cloudwatch schedule event trigger for lambda
not part of aws lambda events
had to implement my self (easy enough)

## kinesis vs cloudwatch events cost
kensis has high basic cost (look up 1 shard monthly cost)
cloudwatch batches together (unable to figure out how this document)

# open issues
## cold starts
cold starts are still a thing
more noticible with current traffic levels
able to 'fix' with webpack

## serverside rendering
nuxt takes too much to build + start
really bad with cold starts
cant easily slim build or modify build to lambda

## dynamodb response time
dax costs too much to be used for this 
takes 1s


## local testing and development

(aws engineers have their own aws accounts at work for their day to day development)

## apigate way vs http gateway 
http gateway still in preview and not in ca-central-1
(general aws region roll out stuff. ca-central-1 is a tier 2 region)

# remaining work

## CI
code build?
- small free tier
- would need yet another stack

azure pipelines
- cheap + free

github actions + pages

## user-agent

## alarms

# conclusions
working with aws + cdk was a great experience but Digital Ocean is still way easier. Not having to worry about costs when there is clear upfront monthly cost (billed hourly but prices are also displayed by the month) . able to closely mirror real production env

ammobin.ca will continue to be run on aws for increased stability and (lower cots????)
