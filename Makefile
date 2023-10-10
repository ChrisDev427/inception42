# Colors
GREEN = \033[32m
B_GREEN = \033[1;32m
B_BLUE = \033[1;34m
RESET = \033[0m

all: volumes up

volumes: ## Create volumes needed
	@echo "$(B_GREEN)checking volumes$(RESET)";
	@if [ ! -d /home/chmassa/data/wordpress ]; then \
		echo "$(B_BLUE)Creating wordpress volume$(RESET)"; \
		mkdir -p /home/chmassa/data/wordpress; \
	fi
	@if [ ! -d /home/chmassa/data/mariadb ]; then \
		echo "$(B_BLUE)Creating mariadb volume$(RESET)"; \
		mkdir -p /home/chmassa/data/mariadb; \
	fi
cleanvol: ## Remove persistant datas
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
up: ## Launch Inception in background
	docker-compose -f ./srcs/docker-compose.yml up -d
down: ## Stop Inception
	docker-compose -f ./srcs/docker-compose.yml down

re: down up ## Restart Inception

stop: ## Stop Inception
	@echo "$(B_BLUE)Stopping all running containers...$(RESET)"
	@for container_id in $$(docker ps -q); do \
        	docker stop $$container_id; \
	done
start: ## Start Inception
	@for container_id in $$(docker ps -qa); do \
		echo "$(B_BLUE)Starting containers -> $$container_id$(RESET)"; \
        	docker start $$container_id; \
	done
	

rm: ## Remove containers
	@echo "$(B_BLUE)Removing containers...$(RESET)"
	@for container_id in $$(docker ps -qa); do \
        	docker rm $$container_id; \
	done


clean: stop rm ## Delete images: 'nginx' 'mariadb' 'wordpress'
	docker rmi nginx
	docker rmi wordpress
	docker rmi mariadb
fclean: ## Remove all Docker images
	@echo "$(B_BLUE)Removing all Docker images...$(RESET)"; \
	docker rmi -f $$(docker images -q); \
	echo "Done.";
logs: ## Print container logs
	@echo "$(B_BLUE)Fetching logs for all running containers...$(RESET)"
	@for container_id in $$(docker ps -q); do \
        	docker logs $$container_id; \
	done

status: ## Print containers status
	@docker-compose -f ./srcs/docker-compose.yml ps

help:
	@ awk 'BEGIN {FS = ":.*##";} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
