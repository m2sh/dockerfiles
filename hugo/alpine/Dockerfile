FROM alpine:3.3
MAINTAINER Mohammad Shahgolzadeh <m2shm2sh@gmail.com>

ENV HUGO_VERSION 0.15
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux_amd64

RUN apk update && apk add py-pygments && rm -rf /var/cache/apk/*

ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /tmp/

RUN  tar -xvzf /tmp/${HUGO_BINARY}.tar.gz -C /tmp/ \
	&& mv /tmp/${HUGO_BINARY}/${HUGO_BINARY} /usr/bin/hugo && rm -rf /tmp/hugo*

CMD ["hugo"]
