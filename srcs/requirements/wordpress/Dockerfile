FROM alpine:3.22.2

RUN apk update && apk add php83 php83-phar php83-mysqli php83-fpm php83-mbstring wget gosu mariadb-client

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

COPY ./conf/docker-entrypoint.sh /usr/local/bin/

RUN echo "memory_limit = 512M" >> /etc/php83/php.ini

ENV HOME=/var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000

CMD ["php-fpm83", "-F"]

