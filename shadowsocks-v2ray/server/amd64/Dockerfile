FROM alpine:latest

LABEL maintainer="Mohammad Shahgolzadeh <m2shm2sh@gmail.com>"

ENV SS_VER=3.2.3
ENV V2RAY_VER=8cea1a3

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
    && curl -fSL https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.0/v2ray-plugin-linux-amd64-$V2RAY_VER.tar.gz | tar xz -C /usr/local/bin v2ray-plugin_linux_amd64 \
    && mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin \
    && RunDeps="$( \
        scanelf --needed --nobanner /usr/local/bin/v2ray-plugin \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .rundeps $RunDeps \
    && apk del .build-deps

# Shadowsocks environment variables
ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT 443
ENV PASSWORD password
ENV ENCRYPT_METHOD chacha20-ietf-poly1305
ENV TIMEOUT 600
ENV DNS_ADDR 8.8.8.8

ENV PLUGIN v2ray-plugin

ENV V2RAY_HOST=example.com
ENV V2RAY_CERT="/certs/fullchain.cer"
ENV V2RAY_KEY="/certs/$V2RAY_HOST.key"

ENV PLUGIN_OPTS "server;tls;host=$V2RAY_HOST;cert=$V2RAY_CERT;key=$V2RAY_KEY"

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

# Start shadowsocks-libev server
CMD ss-server -s "$SERVER_HOST" \
                     -p "$SERVER_PORT" \
                     -k "$PASSWORD" \
                     -m "$ENCRYPT_METHOD" \
                     -t "$TIMEOUT" \
                     -d "$DNS_ADDR" \
                     --plugin "$PLUGIN" \
                     --plugin-opts $PLUGIN_OPTS \
                     -u \
                     --mptcp \
                     --reuse-port \
                     --fast-open \
                     --no-delay