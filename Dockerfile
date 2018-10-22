FROM jekyll/jekyll

COPY . /srv/jekyll
RUN jekyll build .
