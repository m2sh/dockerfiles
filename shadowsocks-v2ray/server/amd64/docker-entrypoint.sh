#!/bin/bash

# Shadowsocks environment variables
SERVER_HOST=${SERVER_HOST:-0.0.0.0}
SERVER_PORT=${SERVER_PORT:-443}
PASSWORD=${SERVER_PORT:-password}
ENCRYPT_METHOD=${ENCRYPT_METHOD:-chacha20-ietf-poly1305}
TIMEOUT=${TIMEOUT:-600}
DNS_ADDR=${DNS_ADDR:-8.8.8.8}


# V2Ray Environment variable
V2RAY_HOST=${V2RAY_HOST:-example.com}
V2RAY_CERT=${V2RAY_CERT:-/certs/fullchain.cer}
V2RAY_KEY=${V2RAY_KEY:-/certs/$V2RAY_HOST.key}

PLUGIN=${PLUGIN:-v2ray-plugin}
PLUGIN_OPTS=${PLUGIN_OPTS:-server;tls;host=$V2RAY_HOST;cert=$V2RAY_CERT;key=$V2RAY_KEY}

ENABLE_UDP=${ENABLE_UDP:-false}
UDP_FLAG=""
if [ "$ENABLE_UDP" == true ]
then
    set -x
    UDP_FLAG="-u"
fi

echo $UDP_FLAG;

if [ "$1" == "ss-server" ]
then
    ss-server -s "$SERVER_HOST" \
              -p "$SERVER_PORT" \
              -k "$PASSWORD" \
              -m "$ENCRYPT_METHOD" \
              -t "$TIMEOUT" \
              -d "$DNS_ADDR" \
              --plugin "$PLUGIN" \
              --plugin-opts $PLUGIN_OPTS \
              --mptcp \
              --reuse-port \
              --fast-open \
              --no-delay \
              $UDP_FLAG;
else
    exec "$@"
fi