FROM node
WORKDIR /app
COPY package.json ./
RUN npm install
#COPY . .
COPY ./ /app
EXPOSE 3000
CMD [ "npm","start" ]

