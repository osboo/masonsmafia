#Развёртывание сервера
1. cd `Checkout directory`
1. Установить LAMP, например [XAMMP](http://help.ubuntu.ru/wiki/xampp)
1. `apt-get install redis-server`
1. `apt-get install nodejs npm`
2. `npm install -g coffee-script`
3. Посмотреть src/server/conf.coffee
Создать базу данных и юзера в соответствие с настройками (проще через phpmyadmin)
4. `coffee src/server/sync.coffee`

Для трансляции клиентских скриптов в js:

`coffee -c -o src/static/js src/client && coffee src/server/app.coffee`
