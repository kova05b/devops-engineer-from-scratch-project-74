FROM node:20.12.2

WORKDIR /app

COPY app/package.json app/package-lock.json ./
RUN npm ci

COPY app/ ./

EXPOSE 8080

CMD ["make", "start"]
