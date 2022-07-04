FROM node:lts-bullseye-slim

RUN apt-get update --silent \
&&  apt-get install -yqq --no-install-suggests --no-install-recommends --silent \
      jq \
      less

USER node:node

WORKDIR /app

RUN mkdir -p /home/node/.local/bin \
             node_modules/.cache/.eslintcache

ENV PATH /home/node/.local/bin:$PATH

ENV NODE_ENV=development

RUN npm config set prefix '~/.local' \
&& npm install --development --location=global \
      copyfiles \
      rimraf \
      twilio-cli \
&&  twilio plugins:install \
      @twilio-labs/plugin-rtc

COPY package.json .
RUN npm install --location=global

COPY . .

# VOLUME /root/.npm/_logs
VOLUME /home/node/.npm/_logs/

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["npm", "start", "--loglevel", "verbose"]
