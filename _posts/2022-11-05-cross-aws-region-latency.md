repo https://github.com/BASED-EDGE/cross-region-latency

question
if my ddb is in a far away region, is it better to call it from a far away lambda or a closer lambda
(ie: DDB is in us-east-1, but i am in us-west-2, should invoke my lambda in us-east-1 or us-west-2)

(if one does not want a global ddb table, which is the perferred solution here)


test
3 setups, for ddb in us-east-1
lambda in us-west-2
lambda in us-east-1
cloudfront infront of us-east-1 lambda (for edge routing)

results
best to just call out to region directly



why would you want to ignore this?
- cross region availability

notes
this only covers a limited use case, best to investigate for yourself

what about different services from just ddb?

![from_ec2](https://user-images.githubusercontent.com/3188890/200147883-bdad71e6-dde4-4e60-b91c-6240b2033048.png)

![load_test_from_home](https://user-images.githubusercontent.com/3188890/200147889-03f98a42-b833-4c3a-8e9e-70eec8e6fbf7.png)
