# stage para desenvolvimento
FROM node:latest AS develop

WORKDIR /app

CMD ["sh", "-c", "npm install && npm start"]

# stage base
FROM node:latest AS node-base

WORKDIR /app

COPY ./src/psvo/package*.json ./
RUN npm install

EXPOSE 3000

# stage para testes
FROM node-base AS test

CMD ["npm", "run", "test"]

# stage de build
FROM node-base AS build

COPY ./src/psvo/ ./
RUN npm run build

# stage de homologação
FROM nginx:alpine AS release

COPY --from=build /app/build /usr/share/nginx/html
COPY ./services/psvo/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# stage de produção
FROM release AS main
