FROM nginx:alpine

COPY . /usr/share/nginx/html

RUN apk add --no-cache bash
