change-hostname:
	sudo sed -i "s/127\.0\.0\.1.*/127.0.0.1\tkvalerii.42.fr/" /etc/hosts

up: ssl_key_gen
	sudo docker compose -f ./srcs/docker-compose.yml up --build -d

down: 
	sudo docker compose -f ./srcs/docker-compose.yml down

ssl_key_gen:
	@SSL_DIR=./secrets/certs; \
	sudo mkdir -p $$SSL_DIR; \
	if [ ! -f "$$SSL_DIR/cert.pem" ] || [ ! -f "$$SSL_DIR/private-key.pem" ]; then \
	    echo "Generating self-signed SSL cert..."; \
	    sudo openssl genrsa -out "$$SSL_DIR/private-key.pem" 3072; \
	    sudo openssl req -new -x509 -key "$$SSL_DIR/private-key.pem" \
	        -out "$$SSL_DIR/cert.pem" -days 360 \
	        -subj "/C=US/ST=California/L=San Francisco/O=MyCompany/OU=IT/CN=localhost/emailAddress=kvalerii@student.codam.nl"; \
	fi

clean:
	sudo rm -rf ~/data/*
	
clean-images:
	sudo docker rmi -f $(shell sudo docker images -aq)
	
images:
	sudo docker images
	
list:
	sudo docker ps -a
