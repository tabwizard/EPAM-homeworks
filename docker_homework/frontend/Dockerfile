FROM node:14-alpine as builder
WORKDIR /frontend
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:14-alpine
WORKDIR /app
COPY --from=builder /frontend .
RUN npm install -g serve
CMD [ "serve", "-s", "build" ]
