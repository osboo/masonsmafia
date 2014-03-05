apt-get instll mysql redis-server nodejs npm phpmyadmin

npm install -g coffee-script

Посмотреть src/server/conf.coffee
Создать базу данных и юзера в соответствие с настройками (проще через phpmyadmin)

coffee src/server/sync.cofee

coffee -c -o scr/static/js src/client && coffee src/server/app.coffee
