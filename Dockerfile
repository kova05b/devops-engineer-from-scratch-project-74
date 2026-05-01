FROM node:20.12.2

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends make=4.3-4.1 \
    && rm -rf /var/lib/apt/lists/*

COPY app/package.json app/package-lock.json ./
RUN npm ci

COPY app/ ./

EXPOSE 8080

CMD ["make", "test"]
