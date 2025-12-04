#!/bin/sh

SSL_DIR=../../../../secrets/certs/; \
mkdir -p $$SSL_DIR; \
if [ ! -f "$$SSL_DIR/cert.pem" ] || [ ! -f "$$SSL_DIR/private-key.pem" ]; then \
    echo "Generating self-signed SSL cert..."; \
    openssl genrsa -out "$$SSL_DIR/private-key.pem" 3072; \
    openssl req -new -x509 -key "$$SSL_DIR/private-key.pem" \
        -out "$$SSL_DIR/cert.pem" -days 360 \
        -subj "/C=US/ST=California/L=San Francisco/O=MyCompany/OU=IT/CN=localhost/emailAddress=kvalerii@student.codam.nl"; \
fi
