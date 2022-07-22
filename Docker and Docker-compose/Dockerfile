FROM node:18-alpine3.14

WORKDIR /home/node/app

COPY . /home/node/app/

RUN npm install \
    && addgroup -S appuser \
    && adduser -S -D -h /home/appuser appuser appuser 

USER appuser

EXPOSE 3000

CMD npm start