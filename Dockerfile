FROM node:19.9.0 as build-stage
#FROM ubuntu:22.04

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .

ENV NODE_OPTIONS="--openssl-legacy-provider"
EXPOSE 8080
CMD [ "npm", "run", "serve" ]