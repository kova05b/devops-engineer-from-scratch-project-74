DOCKER_COMPOSE ?= docker compose

.PHONY: setup dev down lint test test-up ci build push

setup:
	$(DOCKER_COMPOSE) run --rm app sh -lc "make prepare-env && make setup"

dev:
	$(DOCKER_COMPOSE) up app

down:
	$(DOCKER_COMPOSE) down --remove-orphans

lint:
	$(DOCKER_COMPOSE) -f docker-compose.yml run --rm app make lint

test:
	$(DOCKER_COMPOSE) -f docker-compose.yml run --rm app make test

test-up:
	$(DOCKER_COMPOSE) -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

# CI: проверки через Docker Compose и Dockerfile.production (см. docker-compose.yml -f)
ci: lint test

build:
	$(DOCKER_COMPOSE) -f docker-compose.yml build app

push:
	$(DOCKER_COMPOSE) -f docker-compose.yml push app
