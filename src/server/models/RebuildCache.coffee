fs = require('fs')
db = require('./db')
GAME_RESULT = require('./constants').GAME_RESULT
PLAYER_ROLES = require('./constants').PLAYER_ROLES
rating = require('./rating_formula_342')
Sequelize = require('sequelize')

module.exports = (done)->
  db.PlayerGame.all().success((playerGames)->
    chainer = new Sequelize.Utils.QueryChainer
    for playerGame in playerGames
      chainer.add(playerGame, 'getGame', [])
      chainer.add(playerGame, 'getPlayer', [])
    cachedPlayer = {}
    names = []
    chainer.runSerially().success((chainerResults)->
      for i in [0...playerGames.length]
        result = chainerResults[2 * i].result
        playerName = chainerResults[2 * i + 1].name
        playerGame = playerGames[i]
        if not cachedPlayer[playerName]
          names.push(playerName)
          cachedPlayer[playerName] = {
            "rating": 0.0
            "winsCitizen": 0
            "winsSheriff": 0
            "winsMafia": 0
            "winsDon": 0
            "gamesCitizen": 0
            "gamesSheriff": 0
            "gamesMafia": 0
            "gamesDon": 0
            "likes": 0
            "bestPlayer": 0
            "bestMoveAttempts": 0
            "foundedMafiaOnBestMove": 0
            "firstKilledNight": 0
            "firstKilledDay": 0
            "fouls": 0
          }
        cachedPlayer[playerName]["rating"] += rating(playerGame, result)
        cachedPlayer[playerName]["winsCitizen"] += 1 if result == GAME_RESULT.CITIZENS_WIN and playerGame.role == PLAYER_ROLES.CITIZEN
        cachedPlayer[playerName]["winsSheriff"] += 1 if result == GAME_RESULT.CITIZENS_WIN and playerGame.role == PLAYER_ROLES.SHERIFF
        cachedPlayer[playerName]["winsMafia"] += 1 if result == GAME_RESULT.MAFIA_WIN and playerGame.role == PLAYER_ROLES.MAFIA
        cachedPlayer[playerName]["winsDon"] += 1 if result == GAME_RESULT.MAFIA_WIN and playerGame.role == PLAYER_ROLES.DON
        cachedPlayer[playerName]["gamesCitizen"] += 1 if playerGame.role == PLAYER_ROLES.CITIZEN
        cachedPlayer[playerName]["gamesSheriff"] += 1 if playerGame.role == PLAYER_ROLES.SHERIFF
        cachedPlayer[playerName]["gamesMafia"] += 1 if playerGame.role == PLAYER_ROLES.MAFIA
        cachedPlayer[playerName]["gamesDon"] += 1 if playerGame.role == PLAYER_ROLES.DON
        cachedPlayer[playerName]["likes"] += playerGame.likes
        cachedPlayer[playerName]["bestPlayer"] += 1 if playerGame.is_best
        cachedPlayer[playerName]["firstKilledNight"] += 1 if playerGame.is_killed_first_at_night
        cachedPlayer[playerName]["firstKilledDay"] += 1 if playerGame.is_killed_first_by_day
        cachedPlayer[playerName]["fouls"] += playerGame.fouls
        cachedPlayer[playerName]["bestMoveAttempts"] += 1 if playerGame.took_best_move
        cachedPlayer[playerName]["foundedMafiaOnBestMove"] += playerGame.best_move_accuracy if playerGame.took_best_move
      commonStats = []
      for name in names
        if cachedPlayer[name]["bestMoveAttempts"]
          cachedPlayer[name]["bestMoveAccuracy"] = cachedPlayer[name]["foundedMafiaOnBestMove"] / cachedPlayer[name]["bestMoveAttempts"]
        else
          cachedPlayer[name]["bestMoveAccuracy"] = 0.0
        delete cachedPlayer[name]["foundedMafiaOnBestMove"]
        delete cachedPlayer[name]["bestMoveAttempts"]
        cachedPlayer[name]["name"] = name
        commonStats.push(cachedPlayer[name])
      commonStats.sort((a, b)->
        averageA = a.rating / (a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon)
        averageB = b.rating / (b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon)
        return if averageA > averageB then 1 else -1
      )
      top10 = if commonStats.length >= 10 then commonStats[0..10] else commonStats

      fs.writeFile("#{__dirname}/../../static/json/common_stat_responce.json", JSON.stringify(commonStats), (err)->
        if err
          done(err, null)
        else
          fs.writeFile("#{__dirname}/../../static/json/top10.json", JSON.stringify(top10), (err)->
            if err
              done(err, null)
            else
              db.Player.all().success((players)->
                fs.writeFile("#{__dirname}/../../static/json/players.json",
                  JSON.stringify((player.name for player in players)), (err)->
                  if err
                    done(err, null)
                  else
                    done(null, top10)
                )
              ).error((err)->
                done(err, null)
              )
          )
        )
    ).error((err)->
      done(err, null)
    )
  ).error((err)->
    done(err, null)
  )