FROM node:20 as base

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

FROM base as test

RUN apt-get update \
  && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt install -y ./google-chrome*.deb \
  && rm google-chrome-stable_current_amd64.deb

ENV CHROME_BIN=/usr/bin/google-chrome

ENTRYPOINT [ "npm", "run", "test",  "--" ]
CMD [ "--no-watch", "--no-progress", "--browsers=ChromeHeadlessNoSandbox"]

FROM base as build

RUN npm run build

FROM nginx:alpine as final

COPY --from=build /app/dist/project/browser/ /usr/share/nginx/html/
