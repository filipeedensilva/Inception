DOCKER_FILE := srcs/docker-compose.yaml

up: volume
	docker-compose -f $(DOCKER_FILE) up --build

stop:
	docker-compose -f $(DOCKER_FILE) stop

down:
	docker-compose -f $(DOCKER_FILE) down

volume:
	@mkdir -p $$HOME/data/mariadb_vol
	@mkdir -p $$HOME/data/wordpress_vol

clean:
	docker-compose -f $(DOCKER_FILE) down -v --rmi all --remove-orphans

purge:
	sudo rm -rf $$HOME/data/mariadb_vol/*
	sudo rm -rf $$HOME/data/wordpress_vol/*
	- docker stop $$(docker ps -a -q)
	- docker rm $$(docker ps -a -q)
	- docker rmi $$(docker images -q)
	- docker volume rm $$(docker volume ls -q)
	- docker network rm $$(docker network ls -q)
	- docker system prune -a -f
