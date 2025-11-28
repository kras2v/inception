FROM alpine:3.22.2

RUN apk update && apk add nginx nano openssl envsubst

COPY ./conf/docker-entrypoint.sh /usr/local/bin/

COPY ./conf/nginx.conf.template /etc/nginx/nginx.conf.template

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]

