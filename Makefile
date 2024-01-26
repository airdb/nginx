# LABEL Maintainer="airdb team <info@airdb.com>"
# Description="https://github.com/airdb"

SERVICE := nginx-builder
#SERVICE := nginx

help: ## Show help messages
	@echo "Container - ${SERVICE} "
	@echo
	@echo "Usage:\tmake COMMAND"
	@echo
	@echo "Commands:"
	@sed -n '/##/s/\(.*\):.*##/  \1#/p' ${MAKEFILE_LIST} | grep -v "MAKEFILE_LIST" | column -t -c 2 -s '#'

build: ## Build or rebuild docker image
	docker compose build
	#docker compose build --no-cache --progress=plain

push: ## Push docker image
	docker compose push ${SERVICE}

up: ## Create and start containers
	docker compose up -d --force-recreate --remove-orphans ${SERVICE}

start: ## Start services
	docker compose start

stop: ## Stop services
	docker compose stop

restart: ## Restart containers
	docker compose restart

ps: ## List containers
	docker compose ps

log logs: ## View output from containers
	docker compose logs

rm: stop ## Stop and remove stopped service containers
	docker compose rm ${SERVICE}

bash: ## Execute a command in a running container
	docker compose exec ${SERVICE} bash --login

release: ## Release nginx
	docker compose build nginx --no-cache
	docker compose up -d --force-recreate --remove-orphans nginx

