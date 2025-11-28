#!/bin/sh
set -e
echo "Nginx entrypoint started"

envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template \
    > /etc/nginx/nginx.conf && rm -rf /etc/nginx/nginx.conf.template

echo "Waiting for WordPress at $WORDPRESS_DB_HOST:9000..."
while ! nc -z $WORDPRESS_DB_HOST 9000; do
  echo "WordPress not ready, sleeping 1s..."
  sleep 1
done

SSL_DIR=/etc/nginx/ssl
mkdir -p $SSL_DIR

if [ ! -f "$SSL_DIR/cert.pem" ] || [ ! -f "$SSL_DIR/private-key.pem" ]; then
    echo "Generating self-signed SSL cert..."
    openssl genrsa -out "$SSL_DIR/private-key.pem" 3072
    openssl req -new -x509 -key "$SSL_DIR/private-key.pem" \
        -out "$SSL_DIR/cert.pem" -days 360 \
        -subj "/C=US/ST=California/L=San Francisco/O=MyCompany/OU=IT/CN=localhost/emailAddress=kvalerii@student.codam.nl"
fi

exec "$@"
