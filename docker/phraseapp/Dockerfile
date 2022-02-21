FROM alpine:latest

RUN set -ex \
\
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
        curl \
\
    && curl --location --output /usr/local/bin/phraseapp "https://github.com/phrase/phraseapp-client/releases/download/1.14.2/phraseapp_linux_386" \
    && chmod +x /usr/local/bin/phraseapp \
\
	&& apk add ca-certificates && rm -rf /var/cache/apk/* \
\
    && apk del .build-deps \
    && rm -rf /tmp/*

WORKDIR /var/www/occasions-mobile