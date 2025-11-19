FROM alpine:3.22.2

RUN apk update && apk add  mariadb mariadb-client gosu

RUN mkdir -p /run/mysqld /data/mariadb && \
    chown -R mysql:mysql /run/mysqld /data/mariadb

COPY ./conf/my.cnf /etc/mysql/my.cnf

COPY ./conf/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]	
EXPOSE 3306

CMD ["mariadbd"]
