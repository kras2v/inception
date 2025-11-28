change-hostname:
	sudo sed -i "s/127\.0\.0\.1.*/127.0.0.1\tkvalerii.42.fr/" /etc/hosts

up: 
	sudo docker compose -f ./srcs/docker-compose.yml up --build -d

down: 
	sudo docker compose -f ./srcs/docker-compose.yml down

clean:
	sudo rm -rf ~/data/*
	
clean-images:
	sudo docker rmi -f $(shell sudo docker images -aq)
	
images:
	sudo docker images
	
list:
	sudo docker ps -a
