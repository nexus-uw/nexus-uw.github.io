---
layout: post
title: 0.1.0 edge-lambda-url-authorizer is now ready for use
date: '2022-10-30'
author: Simon
tags:
- lambda@edge
- typescript
- aws
---

Today I am happy to announce the release of [edge-lambda-url-authorizer 0.1.0](https://www.npmjs.com/package/edge-lambda-url-authorizer) (ready for actual use)

# What
edge-lambda-url-authorizer is a NodeJS package (with Typescript types) to be deployed a Lambda@Edge handler for Cloudfront origin requests. This package will [sigv4 sign](https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html) the incomming request with the lambda's instance credentials using [aws4](https://www.npmjs.com/package/aws4) before forwarding the request to the origin. The origin is expected to be a [Lambda Function URL](https://aws.amazon.com/blogs/aws/announcing-aws-lambda-function-urls-built-in-https-endpoints-for-single-function-microservices/
) endpoint with IAM_AUTH enabled. 

# Why lambda url -> removed extra (unnecessary) dependency on ApiGateway.
### unessarcy
api gateway has a whole list of features and benefits for using, but for a basic 'please expose my lambda as a public endpoint' it is unnecessary

apigateway is a separate service from lambda (so your chance of something killing your service is higher) us-west-2 had a large apigateway outage earlier this month

### save a few pennies
>Function URL Pricing
>Function URLs are included in Lambda’s request and duration pricing. For example, let’s imagine that you deploy a single Lambda function with 128 MB of memory and an average invocation time of 50 ms. The function receives five million requests every month, so the cost will be $1.00 for the requests, and $0.53 for the duration. The grand total is $1.53 per month, in the US East (N. Virginia) Region.

function url does not cost extra

api gateway costs $ per million requests (after the free tier) https://aws.amazon.com/api-gateway/pricing/
-> this tends to be a larger expense than the underlying lambda

(for ammobin.ca, this line item represented almost 10% of the monthly AWS spend)

# challenges with plain function url
## CORS
browsers will make CORS requests (which are supported) b/c the function url is on a different domain from one's website. This creates an extra round trip for each actual request. (question: do OPTIONS requests add to your aws bill?)

## CSP
need to add lambda url to an Content-Security-Policy 
- different for each stage/region -> more work to generate/maintain
- one more thing to worry about
- multiple function urls require multiple domains to add to the policy

## random/auto generated domain
migrating function urls now requires server updates (instead of pointing to custom domain)

ppl might ask why requests are going off to some random auto generated domain?

if the lambda function were to be deleted + recreated (intentionally or not), unable to get old url back -> risk someone might snag it or have to update a bunch of references to it
(could be very hard if hard coded in client sdks or the like)

## lacks security features (auto scan tools can complain)
aws to their credit, launched with excellent iam policy support for (make sure that account is 'secure')
see https://docs.aws.amazon.com/lambda/latest/dg/urls-auth.html#urls-governance

auto scan tools can flag 'endpoint without authentication enabled', enable IAM_AUTH keeps the bots off your back

## bot protection
cant apply aws waf (but can use lambda throttling)

## caching
req could/should be cached. could be cached by browser, but not by cdn

if one site receives enough traffic, all of these extraneous lambda invocations can start to add up


# solution enable IAM_AUTH + cloudfront
have lambda@edge sign incoming origin request 

## cloudfront features
- custom domain
- caching policy
- AWS Shield + WAF protection
- edge routing (could also do something like https://ramsay.xyz/2022/01/05/release-of-blue-green-static-aws-edge.html to internall route to the closest aws region for backing lambda execution)

## iam auth
apply an iam resource policy (handy for cross account access)

prevents people from calling your api directly (to by pass your cloudfront config)

no more 'api without authentication' security scan issues

### alt
custom header auth -> brittle, not great, does not let people get creative (but current suggested solution on https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistS3AndCustomOrigins.html#concept_lambda_function_url)

sigv4 lambda is ~2ms execution time for p90 so it doesn't cost too much (and execute on origin req, so cache reqs need no exe)

### issue
origins per distribution defaults to 25 (can be increased to ???)
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-limits.html#limits-web-distributions

### next steps 
could be generalized further into a generic sigv4 proxy for aws resources (ie: call dynamoDb or s3 directly). but that is much more complicated (and risky). it would require a very good understanding of IAM policies to properly secure one's resources.


