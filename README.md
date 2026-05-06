### Hexlet tests and linter status
[![Actions Status](https://github.com/kova05b/devops-engineer-from-scratch-project-74/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/kova05b/devops-engineer-from-scratch-project-74/actions)

[![Push workflow](https://github.com/kova05b/devops-engineer-from-scratch-project-74/actions/workflows/push.yml/badge.svg)](https://github.com/kova05b/devops-engineer-from-scratch-project-74/actions/workflows/push.yml)

## JS Fastify Blog in Docker Compose

Проект упакован в Docker и запускается локально через Docker Compose.

### Требования
- Docker и Docker Compose (версия Compose не ниже **1.27.0**)
- GNU Make
- Образ на Docker Hub: **[ruslangilyazov/devops-engineer-from-scratch-project-74](https://hub.docker.com/r/ruslangilyazov/devops-engineer-from-scratch-project-74)** (`latest`)

При полном **`docker compose up`** база **PostgreSQL** поднимается сервисом **`db`** из образа `postgres:latest` (отдельная установка Postgres на хост не нужна).

### Конфигурация (12 factor)
Параметры приложения задаются **переменными окружения**. Шаблон — **`app/.env.example`** (после `make setup` появляется **`app/.env`**, в git не коммитится). Для тестов и продакшена используются **`DATABASE_*`** (см. пример в `.env.example`).

### Быстрый старт

Репозиторий уже содержит приложение в каталоге **`app/`**. Клонируйте этот проект и выполняйте команды **из корня репозитория** (где лежат `Makefile` и `docker-compose.yml`):

```bash
git clone https://github.com/kova05b/devops-engineer-from-scratch-project-74.git
cd devops-engineer-from-scratch-project-74
make setup
make dev
```

По SSH: `git clone git@github.com:kova05b/devops-engineer-from-scratch-project-74.git` — затем то же `cd`, `make setup`, `make dev`.

Если вы делаете проект «с нуля» по методичке и каталога **`app/`** ещё нет, его можно один раз положить из шаблона Hexlet:  
`git clone https://github.com/hexlet-components/js-fastify-blog.git app` и удалить вложенный `.git`: `rm -rf app/.git` (на Windows: `Remove-Item -Recurse -Force app\.git`). После этого снова **`make setup`** и **`make dev`** из корня devops-репозитория.

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

### Структура Compose
- **`docker-compose.yml`** — CI/production-конфигурация: сервис **`db`** (PostgreSQL), сервис **`app`** без проброса портов наружу; используется готовый образ **`${DOCKER_IMAGE:-ruslangilyazov/devops-engineer-from-scratch-project-74:latest}`**, команда **`make test`**.
- **`docker-compose.override.yml`** — локальная разработка: **`Dockerfile`**, том **`./app:/app`**, **`make dev`**, порт приложения **8080**, опционально **Caddy** (80/443).

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

Откройте в браузере **http://localhost:8080** (напрямую до приложения).

С **Caddy** в override (задание 5): **`docker compose up`** — затем **https://localhost** (или **http://localhost**, будет редирект на HTTPS). Браузер запросит доверие к самоподписному сертификату (**tls internal**).

### Production-образ и Docker Hub (задание 3)
1. Создайте на [hub.docker.com](https://hub.docker.com) репозиторий с тем же имени, что и GitHub-репозиторий (`имя_пользователя_hub/devops-engineer-from-scratch-project-74`).
2. Войдите локально: `docker login`
3. В **`docker-compose.yml`** имя образа задаётся как **`${DOCKER_IMAGE:-ruslangilyazov/devops-engineer-from-scratch-project-74:latest}`**. Если логин на Docker Hub другой — задайте переменную **`DOCKER_IMAGE`**, например:

```powershell
$env:DOCKER_IMAGE="myhublogin/devops-engineer-from-scratch-project-74:latest"
make build
make push
```

Сборка и отправка (эквивалент команд из задания):

```bash
docker build -f Dockerfile.production -t ruslangilyazov/devops-engineer-from-scratch-project-74:latest .
docker push ruslangilyazov/devops-engineer-from-scratch-project-74:latest
```

Проверка запуска из образа с Docker Hub:

```bash
docker pull ruslangilyazov/devops-engineer-from-scratch-project-74:latest
docker run --rm -p 8080:8080 -e NODE_ENV=development ruslangilyazov/devops-engineer-from-scratch-project-74:latest make dev
```

Примечание: в актуальных Docker CLI используется **`docker compose`**; классический **`docker-compose`** тоже подходит (версия не ниже **1.27.0**). Переопределение: `make push DOCKER_COMPOSE=docker-compose`.

### Что используется
- `docker-compose.yml` и `docker-compose.override.yml` (в том числе **PostgreSQL** `db`, сервис **caddy**, **`services/caddy/Caddyfile`**, порты **80/443**)
- `Dockerfile` (dev-сборка в override) и `Dockerfile.production` (образ для CI и Docker Hub)
- `.dockerignore` — уменьшает контекст сборки (без `node_modules`, `.git`, compose-файлов и лишних артефактов)
- `Makefile`: **`make setup`**, **`make dev`**, **`make down`**, **`make lint`**, **`make test`**, **`make test-up`**, **`make ci`**, **`make build`**, **`make push`**
- `.github/workflows/push.yml` — линт и тесты **внутри Docker Compose**, сборка образа, push на Docker Hub на **`main`** (секреты **`DOCKER_HUB_USERNAME`**, **`DOCKER_HUB_TOKEN`**)