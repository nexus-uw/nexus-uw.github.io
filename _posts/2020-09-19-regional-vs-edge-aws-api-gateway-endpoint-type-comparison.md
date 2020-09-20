---
layout: post
title: 'Comparison of AWS API Gateway Endpoint Types When Behind a CloudFront Distribution'
date: '2020-09-19'
author: Simon
tags:
- api gateway
- cloudfront
- cdk
- c#
- lambda
---

# background
The [official AWS documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-endpoint-types.html
) does not provide guidance around which endpoint type to use. This becomes relevant when once wants to run their entire website behind Cloudfront.

http://blog.ryangreen.ca/2017/11/03/api-gateway-regional-vs-edge-optimized-endpoints/ does suggest using a REGIONAL endpoint if you also have a Cloudfront distribution, but is lacking further detail in the area.

# setup
For this test, [AWS CDK](https://aws.amazon.com/cdk/) was used to setup all of the infrastructure. It makes it trivial to iterate over a list of options + regions to easy generate everything very quickly (and to update it all when there was a bug). [C#](https://docs.aws.amazon.com/cdk/latest/guide/work-with-cdk-csharp.html) was selected as the language only as a change of pace from the Java + Typescript used at work but to preserve static typing.

The all the infrastructure under test was created in us-east-1. Four identical Cloudfront distributions were created with no caching and response compression enabled. Each distribution had one origin pointing to an API Gateway. Each API Gateway was generated with a combination of EDGE/REGIONAL endpoint type and response compression enabled/disabled so as to test all the different combinations. The api had a single lambda integration pointing to the same lambda. The lambda was written in javascript using nodejs 12 and configured with 125MB of ram. The lambda would immediately respond with 256KB of random text (so as to reflect real world non-cachable responses).

For collecting the test data, a lambda was deployed to every AWS commercial region. The test lambda was again written in javascript, using the nodejs 12 runtime with 125MB of memory configured. For the test, it would make GET requests to the given distribution and wait for the request to finish downloading the response. The clientside measured load time was emitted to cloudwatch as a custom metric.

![aws architecture diagram](/assets/edgy-regions-basic-aws-diagram.png)

# execution
All tests where run async'ly at the same time using the lambda cli on 2020 09 20 21:00:00 UTC. Each test lambda was run for 15mins, and no errors were reported at this time.

[test script used](https://github.com/nexus-uw/edgy-regions/blob/master/loadtest.bash)

# results

### clientside response time metrics

![](/assets/edgy-regions-p50-response-time-by-region-distribution.svg)

![](/assets/edgy-regions-p90-response-time-by-region-distribution.svg)

[source dataset csv](https://github.com/nexus-uw/edgy-regions/blob/master/20200919_results/20200919%20Regional%20Edge%20Load%20Testing%20-%20Sheet1.csv)

### additional Cloudfront distribution metrics
> Origin latency
The total time spent from when CloudFront receives a request to when it starts providing a response to the network (not the viewer), for requests that are served from the origin, not the CloudFront cache. This is also known as first byte latency, or time-to-first-byte. [src](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/viewing-cloudfront-metrics.html#monitoring-console.distributions-additional)


![p50 origin latency](/assets/edgy-regions-p50-cloudfront-origin-latency.png)


![p90 origin latency](/assets/edgy-regions-p90-cloudfront-origin-latency.png)

# conclusions

### REGIONAL is the preferred API Gateway endpoint type when behind a custom Cloudfront distribution

The response times for all regions were lower when the endpoint type was REGIONAL. This is expected because REGIONAL endpoints have one fewer 'hops' (no built in Cloudfront distribution) to go through to get to the lambda integration.
A ~10% response time improvement was observed during the test when using a REGIONAL endpoint.

### API Gateway compression is only suggested for far away users
Nearby users will see a small performance hit, but far away users will see a larger performance gain. Ideally, one would place another API gateway closer to their faraway users if there was enough of them to justify the cost + complexity.

Additionally, compression only added to the response time of EDGE endpoints.

# sources
[github repo with all related code + results dataset](https://github.com/nexus-uw/edgy-regions)

