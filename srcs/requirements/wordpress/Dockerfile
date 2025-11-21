FROM alpine:3.22.2

RUN apk update && apk add php83 php83-phar php83-mysqli php83-fpm wget gosu mariadb-client

COPY ./conf/www.conf /etc/php/8.3/fpm/pool.d/www.conf

COPY ./conf/docker-entrypoint.sh /usr/local/bin/

RUN echo "memory_limit = 512M" >> /etc/php83/php.ini

ENV HOME=/var/www

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000

CMD ["php-fpm83", "-F"]

