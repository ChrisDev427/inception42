all: volumes up

volumes:
	echo "checking volumes";
	@if [ ! -d /home/chmassa/data/wordpress ]; then \
		echo "Creating wordpress volume"; \
		mkdir -p /home/chmassa/data/wordpress; \
	fi
	@if [ ! -d /home/chmassa/data/mariadb ]; then \
		echo "Creating mariadb volume"; \
		mkdir -p /home/chmassa/data/mariadb; \
	fi
cleanvol:
	@if [ -d /home/chmassa/data/wordpress ]; then \
		echo "Cleaning wordpress folder"; \
		rm -r /home/chmassa/data/wordpress; \
		mkdir -p /home/chmassa/data/wordpress; \
	fi
	@if [ -d /home/chmassa/data/mariadb ]; then \
		echo "Cleaning mariadb folder"; \
		rm -r /home/chmassa/data/mariadb; \
		mkdir -p /home/chmassa/data/mariadb; \
	fi
up:
	docker-compose -f ./srcs/docker-compose.yml up -d
down:
	docker-compose -f ./srcs/docker-compose.yml down

re: down up

stop:
	@echo "Stopping all running containers..."
	@for container_id in $$(docker ps -q); do \
        	docker stop $$container_id; \
	done
start:
	@for container_id in $$(docker ps -qa); do \
		echo "Starting containers -> $$container_id"; \
        	docker start $$container_id; \
	done
	

rm:
	@echo "Removing containers..."
	@for container_id in $$(docker ps -qa); do \
        	docker rm $$container_id; \
	done


clean: stop rm
	docker rmi nginx
	docker rmi wordpress
	docker rmi mariadb
fclean:
	@echo "Removing all Docker images..."; \
	docker rmi $$(docker images -q); \
	echo "Done.";
logs:
	@echo "Fetching logs for all running containers..."
	@for container_id in $$(docker ps -q); do \
        	docker logs $$container_id; \
	done
