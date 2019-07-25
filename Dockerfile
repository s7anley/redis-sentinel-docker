FROM redis:4.0.14-alpine
MAINTAINER Ján Koščo (@s7anley)

RUN apk add --no-cache \
        curl \
        bash

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 26379

ENTRYPOINT ["/docker-entrypoint.sh"]
