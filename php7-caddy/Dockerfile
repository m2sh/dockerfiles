FROM m2sh/php7:7.3-alpine

RUN curl --silent --show-error --fail --location \
    --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
    "https://caddyserver.com/download/linux/amd64?plugins=http.expires,http.realip&license=personal" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && /usr/bin/caddy -version

COPY Caddyfile /etc/Caddyfile

WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE 2015

CMD ["/usr/bin/caddy", "--conf", "/etc/Caddyfile", "--log", "stdout"]
