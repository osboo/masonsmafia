# Server installation
1. sudo apt-get install git
1. cd `Checkout directory`
1. Install [MySQL](http://help.ubuntu.ru/wiki/mysql) `sudo apt-get install mysql-server`
1. Install [Workbench](http://dev.mysql.com/downloads/workbench/)
1. `sudo apt-get install nodejs npm`
1. `sudo ln -s /usr/bin/nodejs /usr/bin/node`
1. `sudo npm install -g coffee-script`
1. `sudo coffee -c src`
1. Look at `src/server/conf.coffee`Create schema and user in accordance with `conf` file (it is easier to do this via MySQL Workbench)
1. `coffee src/server/sync.coffee` (For first initialization)

# Run server application:

`coffee -c -o src/static/js src/client && coffee src/server/app.coffee`

# For mocha test run:
1. MASONS_ENV=TEST
1. Создать __masons_test__ базу  данных и юзера в соответствие с настройками (проще через MySQL Workbench)
1. user interface=bdd
1. test directory=`Checkout directory/tests`
1. pre-build step=coffee -c src && coffee -c tests
