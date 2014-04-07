#Развёртывание сервера
1. `apt-get install mysql redis-server nodejs npm phpmyadmin`
2. `npm install -g coffee-script`
3. Посмотреть src/server/conf.coffee
Создать базу данных и юзера в соответствие с настройками (проще через phpmyadmin)
4. `coffee src/server/sync.coffee`

Для трансляции клиентских скриптов в js:

`coffee -c -o src/static/js src/client && coffee src/server/app.coffee`
