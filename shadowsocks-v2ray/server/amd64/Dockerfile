FROM alpine:latest

LABEL maintainer="Mohammad Shahgolzadeh <m2shm2sh@gmail.com>"

ENV SS_VER=3.2.3
ENV V2RAY_VER=8cea1a3
ENV V2RAY_RELEASE=v1.0

RUN set -ex \
    # Build environment setup
    && apk add --no-cache --virtual .build-deps \
        curl \
        autoconf \
        automake \
        build-base \
        c-ares-dev \
        libev-dev \
        libtool \
        libsodium-dev \
        linux-headers \
        mbedtls-dev \
        pcre-dev \
    # Build & install
    && cd /tmp/ \
    && curl -fsSL https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz | tar xz \
    && cd shadowsocks-libev-$SS_VER \
    && ./configure --prefix=/usr --disable-documentation \
    && make install \
    && apk del .build-deps \
    # Runtime dependencies setup
    && apk add --no-cache \
        rng-tools \
        $(scanelf --needed --nobanner /usr/bin/ss-* \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u) \
    && rm -rf /tmp/shadowsocks-libev-$SS_VER

RUN \
    apk add --no-cache --virtual .build-deps curl \
    && curl -fSL https://github.com/shadowsocks/v2ray-plugin/releases/download/$V2RAY_RELEASE/v2ray-plugin-linux-amd64-$V2RAY_VER.tar.gz | tar xz -C /usr/local/bin v2ray-plugin_linux_amd64 \
    && mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin \
    && RunDeps="$( \
        scanelf --needed --nobanner /usr/local/bin/v2ray-plugin \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .rundeps $RunDeps \
    && apk add --update --no-cache bash linux-headers \
    && apk del .build-deps

ENV SERVER_PORT 443

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]
# Start shadowsocks-libev server
CMD [ "ss-server" ]