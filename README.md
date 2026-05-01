### Hexlet tests and linter status
[![Actions Status](https://github.com/kova05b/devops-engineer-from-scratch-project-74/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/kova05b/devops-engineer-from-scratch-project-74/actions)

## JS Fastify Blog in Docker Compose

Проект упакован в Docker и запускается локально через Docker Compose.

### Требования
- Docker
- Docker Compose
- GNU Make

### Быстрый старт
```bash
git clone git@github.com:hexlet-components/js-fastify-blog.git app
rm -rf app/.git
make setup
make dev
```

Оставьте это окно терминала открытым: `make dev` запускает контейнер на переднем плане. Если закрыть его или нажать Ctrl+C, сервис остановится.

Приложение слушает `0.0.0.0:8080` внутри контейнера. Открывать в браузере лучше так:

- [http://localhost:8080](http://localhost:8080) или [http://127.0.0.1:8080](http://127.0.0.1:8080) (особенно на Windows: адрес `http://0.0.0.0:8080` часто не открывается).

Убедитесь, что контейнер запущен:

```bash
docker compose ps
```

В колонке `STATUS` должно быть `running`, а не только `created`.

### Проверка
```bash
make lint
make test
```

### Остановка
```bash
make down
```

### Структура Compose (задания 2–3)
- **`docker-compose.yml`** — только базовый сценарий (без томов): сборка из **`Dockerfile.production`**, образ **`image`** для Docker Hub, команда **`make test`**.
- **`docker-compose.override.yml`** — разработка: сборка из **`Dockerfile`**, том **`./app:/app`**, **`make dev`**, порт **8080**.

Тесты без подмешивания override (как в задании):

```bash
docker compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app
```

Через Makefile:

```bash
make test-up
```

Локальный dev (Compose сам подмешивает `docker-compose.override.yml`):

```bash
make dev
```

Откройте в браузере **http://localhost:8080**.

### Production-образ и Docker Hub (задание 3)
1. Создайте на [hub.docker.com](https://hub.docker.com) репозиторий с тем же имени, что и GitHub-репозиторий (`имя_пользователя_hub/devops-engineer-from-scratch-project-74`).
2. Войдите локально: `docker login`
3. В **`docker-compose.yml`** имя образа задаётся как **`${DOCKER_IMAGE:-ruslangilyazov/devops-engineer-from-scratch-project-74:latest}`**. Если логин на Docker Hub другой — задайте переменную **`DOCKER_IMAGE`**, например:

```bash
set DOCKER_IMAGE=myhublogin/devops-engineer-from-scratch-project-74:latest
make build
make push
```

Сборка и отправка (эквивалент команд из задания):

```bash
docker compose -f docker-compose.yml build app
docker compose -f docker-compose.yml push app
```

Проверка запуска из образа с хаба (после `pull`, если образ собирали не локально):

```bash
docker run -p 8080:8080 -e NODE_ENV=development <ваш образ из Docker Hub> make dev
```

Примечание: в актуальных Docker CLI используется **`docker compose`**; классический **`docker-compose`** тоже подходит (версия не ниже **1.27.0**). Переопределение: `make push DOCKER_COMPOSE=docker-compose`.

### Что используется
- `docker-compose.yml` и `docker-compose.override.yml`
- `Dockerfile` (dev) и `Dockerfile.production` (тесты в базовом compose и образ для Hub)
- `.dockerignore` в корне (исключает `node_modules` из контекста сборки)
- `Makefile` для автоматизации команд
- `.github/workflows/ci.yml` для CI (lint + test на production-образе)