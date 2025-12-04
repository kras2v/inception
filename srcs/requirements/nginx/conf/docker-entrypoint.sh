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

exec "$@"
