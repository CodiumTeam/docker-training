FROM node:14 as base

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY angular.json tsconfig* .browserslistrc ./

FROM base as test

RUN apt-get update \
  && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt install -y ./google-chrome*.deb \
  && rm google-chrome-stable_current_amd64.deb

ENV CHROME_BIN=/usr/bin/google-chrome

COPY karma.conf.js tsconfig.spec.json ./

COPY src src/

ENTRYPOINT [ "npm", "run", "test", "--", "--no-watch", "--no-progress", "--browsers=ChromeHeadlessNoSandbox", "--reporters=junit" ]

FROM base as build

COPY src src/

RUN npm run build

FROM nginx:alpine as final

COPY --from=build /app/dist/my-app /usr/share/nginx/html/
