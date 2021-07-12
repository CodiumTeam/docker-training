FROM node:14-alpine as build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY angular.json tsconfig* .browserslistrc ./

COPY src/ src/

RUN npm run build

FROM nginx:alpine

COPY --from=build /app/dist/my-app /usr/share/nginx/html/