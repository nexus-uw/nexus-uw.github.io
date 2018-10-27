FROM jekyll/jekyll

COPY . /srv/jekyll
VOLUME /usr/local/bundle
RUN jekyll build .
