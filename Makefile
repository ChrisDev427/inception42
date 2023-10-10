# Colors
GREEN = \033[32m
B_GREEN = \033[1;32m
B_BLUE = \033[1;34m
RESET = \033[0m

all: volumes up

volumes:
	@echo "$(B_GREEN)checking volumes$(RESET)";
	@if [ ! -d /home/chmassa/data/wordpress ]; then \
		echo "$(B_BLUE)Creating wordpress volume$(RESET)"; \
		mkdir -p /home/chmassa/data/wordpress; \
	fi
	@if [ ! -d /home/chmassa/data/mariadb ]; then \
		echo "$(B_BLUE)Creating mariadb volume$(RESET)"; \
		mkdir -p /home/chmassa/data/mariadb; \
	fi
cleanvol:
	@if [ -d /home/chmassa/data/wordpress ]; then \
		echo "$(B_BLUE)Cleaning wordpress folder$(RESET)"; \
		rm -r /home/chmassa/data/wordpress; \
		mkdir -p /home/chmassa/data/wordpress; \
	fi
	@if [ -d /home/chmassa/data/mariadb ]; then \
		echo "$(B_BLUE)Cleaning mariadb folder$(RESET)"; \
		rm -r /home/chmassa/data/mariadb; \
		mkdir -p /home/chmassa/data/mariadb; \
	fi
up:
	docker-compose -f ./srcs/docker-compose.yml up -d
down:
	docker-compose -f ./srcs/docker-compose.yml down

re: down up

stop:
	@echo "$(B_BLUE)Stopping all running containers...$(RESET)"
	@for container_id in $$(docker ps -q); do \
        	docker stop $$container_id; \
	done
start:
	@for container_id in $$(docker ps -qa); do \
		echo "$(B_BLUE)Starting containers -> $$container_id$(RESET)"; \
        	docker start $$container_id; \
	done
	

rm:
	@echo "$(B_BLUE)Removing containers...$(RESET)"
	@for container_id in $$(docker ps -qa); do \
        	docker rm $$container_id; \
	done


clean: stop rm
	docker rmi nginx
	docker rmi wordpress
	docker rmi mariadb
fclean:
	@echo "$(B_BLUE)Removing all Docker images...$(RESET)"; \
	docker rmi $$(docker images -q); \
	echo "Done.";
logs:
	@echo "$(B_BLUE)Fetching logs for all running containers...$(RESET)"
	@for container_id in $$(docker ps -q); do \
        	docker logs $$container_id; \
	done
