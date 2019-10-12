---
layout: post
title: 'How ammobin.ca reduced its Nuxt docker container image size by 60% using multi stage builds'
date: '2019-10-11'
author: Simon
tags:
- nuxt
- docker
- ammobin.ca
---

## Background
To run a [nuxt.js]() server in production mode, one needs to 'build' it first using ```nuxt build```.  This generates a node server to host the app and serve the assets as well as generating a 'production' build of the clientside assets.

These build time dependencies are not needed for running the server in production and contribute a lot to the final docker image size. 

In order to both build and run the nuxt server within the same Dockerfile, the below sample will make use of Docker's [multi stage build feature](https://docs.docker.com/develop/develop-images/multistage-build/)


## changes
In the below case, the nuxt client for [ammobin.ca](https://ammobin.ca) will used.

### Old dockerfile ([src](https://github.com/ammobinDOTca/ammobin-client/blob/97a7d5b2964cf8b4760309be47d3e32657f8507d/Dockerfile))
```docker
FROM node:12-alpine
RUN apk --no-cache add wget git g++ make python

WORKDIR /build
COPY package*.json /build/
RUN npm install #--production
RUN apk --no-cache del git g++ make python
COPY . /build

EXPOSE 3000
RUN npm run build
HEALTHCHECK --interval=30s --timeout=1s CMD wget localhost:3000/ping -q  -O/dev/null || exit 1

CMD npm start
```
#### build size 732MB (304MB compressed)


### New dockerfile ([src](https://github.com/ammobinDOTca/ammobin-client/blob/b9a0c3b0a1bf7010885f1ba32da43bbc7a05de83/Dockerfile))
```docker
####
# build: pull in + install everything to run nuxt build
####

FROM node:12-alpine as build
RUN apk --no-cache add wget git g++ make python

WORKDIR /build
COPY package*.json /build/
RUN npm install
RUN apk --no-cache del git g++ make python
COPY . /build

RUN npm run build


########
# run: do production install + copy build output of build container and run the node server
########
FROM node:12-alpine as main

WORKDIR /build
COPY --from=build /build/package*.json /build/
RUN npm install --production

# copy min needed to run (built) app
COPY --from=build /build/nuxt.config.ts /build
COPY --from=build /build/.nuxt /build/.nuxt
COPY --from=build /build/static /build/static
RUN apk --no-cache add wget

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=1s CMD wget localhost:3000/ping -q  -O/dev/null || exit 1

USER node
CMD npm start
```

#### build size 295MB (110MB compressed)


## conclusion
By isolating the build dependencies from the server dependencies, the final image size was reduced by 60% (64% compressed). While the old build size was not a blocking issue, the reduced size speeds up updates, reduces downtime, and saves some disk space (ammobin.ca runs on a single 20GB VPS using docker-compose).
