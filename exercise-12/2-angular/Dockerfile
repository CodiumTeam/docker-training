FROM node:22 AS base

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY angular.json tsconfig* ./


FROM base AS test

RUN apt-get update \
  && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt install -y ./google-chrome*.deb \
  && rm google-chrome-stable_current_amd64.deb

ENV CHROME_BIN=/usr/bin/google-chrome

COPY src src/

ENTRYPOINT [ "npm", "run", "test", "--", "--no-watch", "--no-progress", "--browsers=ChromeHeadlessNoSandbox", "--reporters=junit" ]


FROM base AS build

COPY src src/

RUN npm run build


FROM nginx:alpine AS final

COPY --from=build /app/dist/my-app/browser /usr/share/nginx/html/
