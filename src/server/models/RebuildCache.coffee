fs = require('fs')
db = require('./db')
GAME_RESULT = require('./constants').GAME_RESULT
PLAYER_ROLES = require('./constants').PLAYER_ROLES
rating = require('./rating_formula_342')
Sequelize = require('sequelize')

module.exports = (done)->
  db.Player.all().success((players)->
    commonStat = []
    for player in players
      cachedPlayer = {
        "name": null
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
        "bestMoveAccuracy": 0.0
        "firstKilledNight": 0
        "firstKilledDay": 0
        "fouls": 0
      }
      cachedPlayer["name"] = player.name
      cachedPlayer["rating"] = 0.0
      bestMoveAttempts = 0
      foundedMafiaOnBestMove = 0
      chainer = new Sequelize.Utils.QueryChainer
      chainer.add(db.PlayerGame.findAll({where: {PlayerId: player.id}}))
      chainer.run().success((results)->
        playerGames = results[0]
        for playerGame in playerGames
          chainer2 = new Sequelize.Utils.QueryChainer
          chainer2.add(playerGame.getGame())
          chainer2.run().success((game)->
            cachedPlayer["rating"] += rating(playerGame, game.result)
            cachedPlayer["winsCitizen"] += 1 if game.result == GAME_RESULT.CITIZENS_WIN and playerGame.role == PLAYER_ROLES.CITIZEN
            cachedPlayer["winsSheriff"] += 1 if game.result == GAME_RESULT.CITIZENS_WIN and playerGame.role == PLAYER_ROLES.SHERIFF
            cachedPlayer["winsMafia"] += 1 if game.result == GAME_RESULT.MAFIA_WIN and playerGame.role == PLAYER_ROLES.MAFIA
            cachedPlayer["winsDon"] += 1 if game.result == GAME_RESULT.MAFIA_WIN and playerGame.role == PLAYER_ROLES.DON
          ).error((err)->
            done(err, null)
          )
          cachedPlayer["gamesCitizen"] += 1 if playerGame.role == PLAYER_ROLES.CITIZEN
          cachedPlayer["gamesSheriff"] += 1 if playerGame.role == PLAYER_ROLES.SHERIFF
          cachedPlayer["gamesMafia"] += 1 if playerGame.role == PLAYER_ROLES.MAFIA
          cachedPlayer["gamesDon"] += 1 if playerGame.role == PLAYER_ROLES.DON
          cachedPlayer["likes"] += playerGame.likes
          cachedPlayer["bestPlayer"] += 1 if playerGame.is_best
          cachedPlayer["firstKilledNight"] += 1 if playerGame.is_killed_first_at_night
          cachedPlayer["firstKilledDay"] += 1 if playerGame.is_killed_first_by_day
          cachedPlayer["fouls"] += playerGame.fouls
          bestMoveAttempts += 1 if playerGame.took_best_move
          foundedMafiaOnBestMove += playerGame.best_move_accuracy if playerGame.took_best_move

        if bestMoveAttempts > 0
          cachedPlayer["bestMoveAccuracy"] = foundedMafiaOnBestMove / bestMoveAttempts
        commonStat.push(cachedPlayer)
        console.log(cachedPlayer)
      ).error((err)->
        done(err, null)
      )
    fs.writeFile("#{__dirname}/../../static/common_stat_responce.json", JSON.stringify(commonStat), (err)->
      if err
        done(err, null)
      else
        done(null, commonStat)
    )
  ).error((err)->
    done(err, null)
  )