ARG NODE_IMAGE=node:20-alpine

FROM $NODE_IMAGE AS base
RUN apk --no-cache add dumb-init
RUN mkdir -p /home/node/app && chown node:node /home/node/app
WORKDIR /home/node/app
USER node
RUN mkdir tmp

FROM base AS dependencies
COPY --chown=node:node ./package*.json ./
RUN npm ci
COPY --chown=node:node . .

FROM dependencies AS build
RUN node ace build --production

FROM base AS production
ENV NODE_ENV=production
ENV PORT=3333
ENV HOST=0.0.0.0
ENV APP_KEY=GcEODbhWco7ymDqOnA8qzjrkd5XKKCw6
ENV DRIVE_DISK=local
ENV DB_CONNECTION=pg
ENV PG_DB_NAME=ios_dev
ENV PG_HOST=ios_db
ENV PG_USER=postgres
ENV PG_PASSWORD=jkf&.i3+eTDkds49
ENV PG_DATABASE=ios_prod
COPY --chown=node:node ./package*.json ./
RUN npm ci --production
COPY --chown=node:node --from=build /home/node/app/build .
EXPOSE 3333
CMD [ "dumb-init", "node", "server.js" ]