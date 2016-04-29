FROM redis:3.0.7-alpine
MAINTAINER Ján Koščo (@s7anley)

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 26379

ENTRYPOINT ["/docker-entrypoint.sh"]
