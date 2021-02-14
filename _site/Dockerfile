FROM jekyll/jekyll as BUILD

COPY . /srv/jekyll
VOLUME /usr/local/bundle
RUN jekyll build .


FROM nginx:alpine
WORKDIR /site
COPY --from=BUILD /srv/jekyll/_site /site
RUN npm install -g serve
EXPOSE 5000
CMD serve
