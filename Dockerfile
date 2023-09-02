FROM node
WORKDIR /app
COPY package.json ./
COPY . .
#COPY ./ /app
EXPOSE 3000
CMD [ "npm","start" ]

