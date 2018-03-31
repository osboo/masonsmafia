FROM mysql:latest

# Prepare sync script that can be triggered outside

# Install npm and coffee
RUN apt-get update && apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get remove gyp
RUN apt-get -y install nodejs build-essential npm
RUN npm install -g coffeescript

# Install sequalize
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

# Transpile sources to build db/models
RUN coffee -c src

# Now src/server/sync coffee is ready to be launched

# Expose port
EXPOSE 3306