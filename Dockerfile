FROM node
WORKDIR /app
#COPY package.json ./
COPY . .
#CMD npm install
EXPOSE 3000
CMD npm start

