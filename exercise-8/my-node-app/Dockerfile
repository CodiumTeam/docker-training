FROM node:14-alpine:v1

WORKDIR /app

COPY package*.json .

RUN npm ci

ENTRYPOINT [ "node" ]
CMD [ "/index.js" ]
