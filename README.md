#Развёртывание сервера
1. `apt-get install mysql redis-server nodejs npm phpmyadmin`
2. `npm install -g coffee-script`
3. Посмотреть src/server/conf.coffee
Создать базу данных и юзера в соответствие с настройками (проще через phpmyadmin)
4. `coffee src/server/sync.coffee`

Для трансляции клиентских скриптов в js:

`coffee -c -o scr/static/js src/client && coffee src/server/app.coffee`

#Формат данных объекта Game на клиентской стороне
'date': timestamp
'role': 'citizen' может быть sheriff, mafia, don
'rating': double value
'maxPossibleRating': double value. Константа в зависимости от формулы рейтинга
'win': 1 - выиграл, 0 - проиграл
'isBestPlayer': 1 - был помечен как лучший в ведомости, 0 - не был помечен
'bestMove':
-1 - не пользовался,
0, 1, 2, 3 - пользовался и угадал соответствующее количество мафов
В случае, если первым был сострелен маф, его лучший ход не защитывается и не заносится в базу (ставится -1)
'likes': 2
'fauls': 3,
'isKilledNight': 0 - не был убит первую ночь, 1 - был убит в первую ночь
'isKilledDay': 0 - не был поднят в первый день, 1 - был поднят в первый день