FROM alpine

ENV SS_VER=3.2.0
ENV KCP_VER 20190109
ENV ARCH=amd64

RUN \
    set -ex \
    && apk add --no-cache --virtual .build-deps \
        curl \
        autoconf \
        build-base \
        libtool \
        linux-headers \
        libressl-dev \
        zlib-dev \
        asciidoc \
        xmlto \
        pcre-dev \
        automake \
        mbedtls-dev \
        libsodium-dev \
        c-ares-dev \
        libev-dev \
    && apk add --no-cache --virtual .run-deps \
        pcre \
        libev \
        c-ares \
        libsodium \
        mbedtls \
    && curl -fsSL https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz | tar xz \
    && cd shadowsocks-libev-$SS_VER \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf shadowsocks-libev-$SS_VER \
    && apk del .build-deps


RUN \
    apk add --no-cache --virtual .build-deps curl \
    && curl -fSL https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-$ARCH-$KCP_VER.tar.gz | tar xz -C /usr/local/bin client_linux_$ARCH \
    && apk del .build-deps \
    && apk add --no-cache supervisor

COPY supervisord.conf /etc/supervisord.conf

ENV KCP_SERVER_PORT=9443 KCP_KEY=123456 KCP_CRYPT=none KCP_MODE=fast3 MTU=1200 SNDWND=128 RCVWND=512 DATASHARD=10 PARITYSHARD=0 SS_LOCAL_PORT=1080 SS_METHOD=salsa20 SS_PORT=443 SS_TIMEOUT=300

ENTRYPOINT ["/usr/bin/supervisord"]
