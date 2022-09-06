FROM jekyll/jekyll as BUILD

VOLUME /usr/local/bundle
COPY . /tmp
WORKDIR /tmp
RUN jekyll build --destination /tmp/ASS . && ls

FROM ghcr.io/nexus-uw/darkhttpd:master
EXPOSE 80
COPY --from=BUILD /tmp/ASS /var/www/htdocs
