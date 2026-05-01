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

### Структура Compose (задание 2)
- `docker-compose.yml` — базовый файл: сервис **`app`**, том `./app:/app`, команда по умолчанию **`make test`** (используется вместе с флагом `-f docker-compose.yml`, чтобы не подмешивался override).
- `docker-compose.override.yml` — локальная разработка: **`make dev`**, порт **`8080`**. Обычный **`docker compose up`** подмешивает override и поднимает приложение для разработки.

Тесты только из базового файла (override не используется):

```bash
docker compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app
```

Или через Makefile:

```bash
make test-up
```

Локальный dev с подмешиванием override:

```bash
make dev
```

Откройте в браузере **http://localhost:8080**.

Примечание: в актуальных Docker CLI команда выглядит как `docker compose`; классический бинарь `docker-compose` при наличии тоже подходит (версия не ниже **1.27.0**). При необходимости переопределите переменную `DOCKER_COMPOSE`, например: `make test-up DOCKER_COMPOSE=docker-compose`.

### Что используется
- `docker-compose.yml` и `docker-compose.override.yml`
- `.dockerignore` в корне (исключает `node_modules` из контекста сборки)
- `Dockerfile` для сборки образа приложения
- `Makefile` для автоматизации команд
- `.github/workflows/ci.yml` для CI (lint + test)