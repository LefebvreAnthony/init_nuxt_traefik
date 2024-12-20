FROM node:23-alpine

WORKDIR /app

COPY --chmod=0755 ./scripts/web-entrypoint.sh /usr/local/bin/web-entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/web-entrypoint.sh" ]

EXPOSE 3000

CMD [ "npm","run","dev" ]