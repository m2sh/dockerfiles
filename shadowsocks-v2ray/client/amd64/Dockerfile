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

# Update ca-certificates for new CAs (ssl providers)
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
        ca-certificates@edge \
        curl@edge


# Shadowsocks environment variables
ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT 443
ENV LOCAL_PORT=1080
ENV PASSWORD password
ENV ENCRYPT_METHOD chacha20-ietf-poly1305
ENV TIMEOUT 600

# V2ray plugin environment variables
ENV PLUGIN v2ray-plugin
ENV V2RAY_HOST=example.com

ENV PLUGIN_OPTS "tls;host="

HEALTHCHECK --start-period=5s \
  CMD curl -x socks5h://localhost:$LOCAL_PORT -f https://docker.com/ || exit 1

CMD ss-local -s "$SERVER_HOST" \
                     -p "$SERVER_PORT" \
                     -k "$PASSWORD" \
                     -l "$LOCAL_PORT" \
                     -b "0.0.0.0" \
                     -m "$ENCRYPT_METHOD" \
                     -t $TIMEOUT \
                     --plugin "$PLUGIN" \
                     --plugin-opts "$PLUGIN_OPTS$V2RAY_HOST" \
                     -u \
                     --fast-open \
                     --no-delay