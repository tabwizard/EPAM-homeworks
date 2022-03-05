FROM node:14-alpine as builder
WORKDIR /frontend
COPY package*.json ./
RUN npm install
COPY . .
RUN sed -i 's/http:\/\/localhost:8000//g' ./src/*.js
RUN npm run build

FROM nginx:1.20
WORKDIR /app
COPY --from=builder /frontend/build .
ADD demo.conf /etc/nginx/conf.d/default.conf
