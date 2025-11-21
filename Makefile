all:
	sudo apt update && sudo apt install -y \
	  docker-ce docker-compose \
	  mariadb-client
	  
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
