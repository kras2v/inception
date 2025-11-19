all:
	sudo apt update && sudo apt install -y \
	  docker-ce docker-compose \
	  mariadb-client
	  
	sudo mkdir -p ~/data/wordpress
	sudo mkdir -p ~/data/mariadb
	
	sudo chown -R www-data:www-data ~/data/wordpress
	sudo chown -R mysql:mysql ~/data/mariadb
	
up: 
	sudo docker-compose -f ./srcs/docker-compose.yml up --build -d
	
down: 
	sudo docker-compose -f ./srcs/docker-compose.yml down
	
clean-images:
	sudo docker rmi -f $(shell sudo docker images -aq)
	
images:
	sudo docker images
	
list:
	sudo docker ps -a
