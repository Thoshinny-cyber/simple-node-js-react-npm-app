FROM node
WORKDIR /app
#COPY package.json ./
RUN npm install
COPY . .
#CMD npm install
EXPOSE 3000
CMD npm start

