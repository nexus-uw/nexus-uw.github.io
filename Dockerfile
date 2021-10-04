FROM jekyll/jekyll as BUILD

VOLUME /usr/local/bundle
COPY . /tmp
WORKDIR /tmp
RUN jekyll build --destination /tmp/ASS . && ls

FROM nginx:alpine
COPY --from=BUILD /tmp/ASS /usr/share/nginx/html
