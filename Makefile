DOCKER_COMPOSE = docker compose

.PHONY: setup dev down lint test ci build

setup:
	$(DOCKER_COMPOSE) run --rm app sh -lc "make prepare-env && make setup"

dev:
	$(DOCKER_COMPOSE) up app

down:
	$(DOCKER_COMPOSE) down --remove-orphans

lint:
	$(DOCKER_COMPOSE) run --rm app make lint

test:
	$(DOCKER_COMPOSE) run --rm app make test

ci: lint test

build:
	$(DOCKER_COMPOSE) build app
