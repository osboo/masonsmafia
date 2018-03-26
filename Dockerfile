FROM node:carbon

# Create app directory
WORKDIR /usr/src/app

# Install coffeescript
RUN npm install -g coffeescript

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

# Transpile sources and tests
RUN coffee -c src && coffee -c tests

# Build frontend
RUN npm run build

# Run server
EXPOSE 3000
CMD [ "npm", "start" ]
