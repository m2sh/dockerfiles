FROM m2sh/php7:7.1-alpine

RUN apk add --update --no-cache openldap-dev \
    && docker-php-ext-configure ldap --with-libdir=lib/ \
    && docker-php-ext-install ldap

CMD ["php-fpm"]