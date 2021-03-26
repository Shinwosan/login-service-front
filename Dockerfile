FROM node:14-alpine as base
RUN apk add --no-cache git file re2c autoconf make g++ build-base
#install python, this is needed by opensea-creatures
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

WORKDIR /src
COPY package*.json ./
EXPOSE 3000

FROM base as production
ENV NODE_ENV=production
RUN npm ci
COPY . ./
CMD ["node", "bin/www"]

FROM base as dev
ENV NODE_ENV=development
RUN npm install -g nodemon && npm install
#RUN npm install -g nodemon
COPY . ./
CMD ["nodemon", "bin/www"]
