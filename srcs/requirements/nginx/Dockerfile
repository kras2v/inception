FROM alpine:3.22.2

RUN apk update && apk add nginx nano openssl

RUN mkdir /etc/nginx/ssl/

WORKDIR /etc/nginx/ssl

RUN openssl genrsa -out private-key.pem 3072 && openssl req -new -x509 -key private-key.pem -out cert.pem -days 360 -subj "/C=US/ST=California/L=San Francisco/O=MyCompany/OU=IT/CN=localhost/emailAddress=kvalerii@student.codam.nl"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

WORKDIR /

CMD ["nginx", "-g", "daemon off;"]

