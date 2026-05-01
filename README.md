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

### Что используется
- `docker-compose.yml` для локального окружения
- `Dockerfile` для сборки образа приложения
- `Makefile` для автоматизации команд
- `.github/workflows/ci.yml` для CI (lint + test)