FROM alpine:3.4 as postgres-pg_dump

RUN apk add --update --no-cache postgresql

FROM m2sh/php7:7.3-alpine

COPY --from=postgres-pg_dump /usr/bin/pg_dump /usr/bin/pg_dump

RUN apk add --update --no-cache postgresql-dev postgresql-client

RUN apk add --update --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.11/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.11/community \
    mongodb-tools

# mysqli, pdo, pdo_mysql
RUN docker-php-ext-install pdo_pgsql

CMD ["php-fpm"]
