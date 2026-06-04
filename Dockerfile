FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install
RUN apk update && apk add curl

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
