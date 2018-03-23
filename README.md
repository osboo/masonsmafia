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
1. Look at `src/server/conf.coffee`. Create schema and user in accordance with `conf` file (it is easier to do this via MySQL Workbench)
1. `export MYSQL_HOST=localhost && coffee src/server/sync.coffee` (For first initialization)

# Run server application:

`coffee -c -o src/static/js src/client && coffee src/server/app.coffee`

# For mocha test run:
1. MASONS_ENV=TEST
1. Create __masons_test__ schema and user in accordane with `conf` (it is easier via MySQL Workbench)
1. user interface=bdd
1. test directory=`Checkout directory/tests`
1. pre-build step=coffee -c src && coffee -c tests

# Running server container
First, run database container. See [here](https://github.com/osboo/masonsmafia-db/blob/master/README.md#run-the-container)

Then run container in user defined network:

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

Before the first run the database should be initialized by app-required schema and user settings. See [here](https://github.com/osboo/masonsmafia-db#initialization)
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
          
 Then initialize the fresh local store. See database documentation [here](https://github.com/osboo/masonsmafia-db/blob/master/README.md#initialization-for-tests) 
 Then spin up containers:
    
    docker-compose -f docker-compose.test.yml up

- For unit-tests call: `docker exec -it testapp ./node_modules/mocha/bin/mocha -u bdd ./tests/unit-tests`
- For integration tests (db): `docker exec -it testapp ./node_modules/mocha/bin/mocha -u bdd ./tests/dbtest`
- For integration tests (add new games): `docker exec -it testapp ./node_modules/mocha/bin/mocha -u bdd ./tests/personal_statistics_test`
