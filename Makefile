DOCKER_COMPOSE ?= docker compose
DOCKER_IMAGE ?= ruslangilyazov/devops-engineer-from-scratch-project-74:latest

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
	docker build -f Dockerfile.production -t $(DOCKER_IMAGE) .

push:
	docker push $(DOCKER_IMAGE)
