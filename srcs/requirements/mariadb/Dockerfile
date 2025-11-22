FROM alpine:3.22.2

RUN apk update && apk add  mariadb mariadb-client gosu

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

COPY ./conf/custom-mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY ./conf/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]	
EXPOSE 3306

CMD ["mariadbd"]
