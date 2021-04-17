FROM jekyll/jekyll as BUILD

COPY . /srv/jekyll
VOLUME /usr/local/bundle
RUN jekyll build .


FROM nginx:alpine
COPY --from=BUILD /srv/jekyll/_site  /usr/share/nginx/html
