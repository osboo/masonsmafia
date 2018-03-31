# Server installation
1. sudo apt-get install git
1. cd `Checkout directory`
1. Install [MySQL](http://help.ubuntu.ru/wiki/mysql) `sudo apt-get install mysql-server`
1. Install [Workbench](http://dev.mysql.com/downloads/workbench/)
1. `curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -`
1. `sudo apt-get install -y nodejs`
1. `sudo npm install -g coffeescript`
1. `coffee -c src`
1. `npm install`
1. `npm run build`
1. `export MYSQL_HOST=localhost && coffee src/server/init.coffee` (For first initialization)

# Run server application:

`export MYSQL_HOST=localhost && npm start`

# For mocha test run:
1. MASONS_ENV=TEST
1. Create __masons_test__ schema and user in accordane with `conf` (it is easier via MySQL Workbench)
1. user interface=bdd
1. test directory=`Checkout directory/tests`
1. pre-build step=`coffee -c src && coffee -c tests`

# Running server container
First, run database container.

## Run the database container

    docker network create mynet
    docker run -d -p 3306:3306 \
    --env "MYSQL_ROOT_PASSWORD=<PASSWORD>" \
    --env "MYSQL_HOST=<CONTAINER NAME>" \
    --name <CONTAINER NAME> \
    --volume <LOCAL PATH>:/var/lib/mysql \
    --net mynet \
    osboo/masonsmafia-db

## Initialization of database
If `<LOCAL PATH>` contains data then the container works with it. If there is a need in firsr database initialization (fresh install or running in testing envrironment) then following command should be executed:

    docker exec -it -e MYSQL_ROOT_PASSWORD=<PASSWORD> <DB CONTAINER NAME> coffee src/server/init.coffee
    
## Initialization for tests
Before each Mocha tests run the database should be initialized. Please also note that the container volume should be stateless so it must be cleaned after each test run.
Command to inititialize the database in test env:

    docker exec -it -e MYSQL_ROOT_PASSWORD=<PASSWORD> -e MASONS_ENV=TEST <DB CONTAINER NAME> coffee src/server/init.coffee

## Running the app
Then run container in user defined network (`mynet` in this example):

    docker run -p 3000:3000 \
    --name <APP CONTAINER NAME> \
    --env "MYSQL_HOST=<DB CONTAINER NAME>" \
    --net mynet \
    osboo/masonsmafia-app

# Run via docker-compose
Create __docker-compose.yml__ file with following:

    version: '3'

    services:
      db:
        image: osboo/masonsmafia-db
        container_name: <DB CONTAINER NAME>
        volumes:
          - <LOCAL PATH>:/var/lib/mysql
        environment:
          MYSQL_ROOT_PASSWORD: <PASSWORD>
          MYSQL_HOST: db

      app:
        depends_on:
          - db
        image: osboo/masonsmafia-app
        container_name: <APP CONTAINER NAME>
        ports:
          - "3000:3000"
        environment:
          MYSQL_HOST: db
          
Then run:

    docker-compose up

Before the first run the database should be initialized by app-required schema and user settings.
Aliases `<DB CONTAINER NAME>` and `<APP CONTAINER NAME>` will define the name of containers to apply initialization command (by default docker creates containers with random unpredictable names).

# Run Mocha tests via docker
Make __docker-compose.test.yml__ with following configuration:

    version: '3'

    services:
      db:
        image: osboo/masonsmafia-db
        container_name: testdb
        volumes:
          - <TEMPORARY LOCAL STORAGE>:/var/lib/mysql
        environment:
          MYSQL_ROOT_PASSWORD: mypassword
          MYSQL_HOST: db

      app:
        depends_on:
          - db
        image: osboo/masonsmafia-app
        container_name: testapp
        ports:
          - "3000:3000"
        environment:
          MYSQL_HOST: db
          MASONS_ENV: TEST
          
 Then initialize the fresh local store.
 Then spin up containers:
    
    docker-compose -f docker-compose.test.yml up

- For unit-tests call: `docker exec -it testapp ./node_modules/mocha/bin/mocha -u bdd ./tests/unit-tests`
- For integration tests (db): `docker exec -it testapp ./node_modules/mocha/bin/mocha -u bdd ./tests/dbtest`
- For integration tests (add new games): `docker exec -it testapp ./node_modules/mocha/bin/mocha -u bdd ./tests/personal_statistics_test`
