db = require('./db')
Sequelize = require('sequelize')
PLAYER_ROLES = require('./constants').PLAYER_ROLES
GAME_RESULT = require('./constants').GAME_RESULT
rating = require('./rating_formula_342')

module.exports = (playerName, done)->
  handleError = (err)->
    if err
      done(err, null)
  profile = {
    "name": "",
    "rating": 0,
    "winsCitizen": 0,
    "winsSheriff": 0,
    "winsMafia": 0,
    "winsDon": 0,
    "gamesCitizen": 0,
    "gamesSheriff": 0,
    "gamesMafia": 0,
    "gamesDon": 0,
    "likesCitizen": 0,
    "likesSheriff": 0,
    "likesMafia": 0,
    "likesDon": 0,
    "bestPlayerCitizen": 0,
    "bestPlayerSheriff": 0,
    "bestPlayerMafia": 0,
    "bestPlayerDon": 0,
    "bestMoveAccuracy": 0.0,
    "firstKilledNightCitizen": 0,
    "firstKilledNightSheriff": 0,
    "firstKilledNightMafia": 0,
    "firstKilledNightDon": 0,
    "firstKilledDayCitizen": 0,
    "firstKilledDaySheriff": 0,
    "firstKilledDayMafia": 0,
    "firstKilledDayDon": 0,
    "foulsCitizen": 0,
    "foulsSheriff": 0,
    "foulsMafia": 0,
    "foulsDon": 0
    "efficiency": []
  }
  db.Player.find({where: {name: playerName}}).success((player)->
    db.PlayerGame.findAll({where: {PlayerId: player.id}}).success((playerGames)->
      chainer = new Sequelize.Utils.QueryChainer
      for playerGame in playerGames
        chainer.add(playerGame, 'getGame', [])
      chainer.runSerially().success((games)->
        profile.name = playerName
        bestMoveAttempts = 0
        foundedMafiaOnBestMove = 0
        for i in [0...playerGames.length]
          result = games[i].result
          delta = 0
          if playerGame.role in [PLAYER_ROLES.CITIZEN, PLAYER_ROLES.SHERIFF]
            delta = if result == GAME_RESULT.CITIZENS_WIN then 1 else -1
          if playerGame.role in [PLAYER_ROLES.MAFIA, PLAYER_ROLES.DON]
            delta = if result == GAME_RESULT.MAFIA_WIN then 1 else -1
          profile.efficiency.push({
            gameID: games[i].id
            date: games[i].date
            winsMinusLosses: delta
          })
          profile.rating += rating(playerGame, result)
          profile.winsCitizen += 1 if result == GAME_RESULT.CITIZENS_WIN and playerGame.role == PLAYER_ROLES.CITIZEN
          profile.winsSheriff += 1 if result == GAME_RESULT.CITIZENS_WIN and playerGame.role == PLAYER_ROLES.SHERIFF
          profile.winsMafia += 1 if result == GAME_RESULT.MAFIA_WIN and playerGame.role == PLAYER_ROLES.MAFIA
          profile.winsDon += 1 if result == GAME_RESULT.MAFIA_WIN and playerGame.role == PLAYER_ROLES.DON
          profile.gamesCitizen += 1 if playerGame.role == PLAYER_ROLES.CITIZEN
          profile.gamesSheriff += 1 if playerGame.role == PLAYER_ROLES.SHERIFF
          profile.gamesMafia += 1 if playerGame.role == PLAYER_ROLES.MAFIA
          profile.gamesDon += 1 if playerGame.role == PLAYER_ROLES.DON
          profile.likesCitizen += playerGame.likes if playerGame.role == PLAYER_ROLES.CITIZEN
          profile.likesSheriff += playerGame.likes if playerGame.role == PLAYER_ROLES.SHERIFF
          profile.likesMafia += playerGame.likes if playerGame.role == PLAYER_ROLES.MAFIA
          profile.likesDon += playerGame.likes if playerGame.role == PLAYER_ROLES.DON
          profile.bestPlayerCitizen += 1 if playerGame.role == PLAYER_ROLES.CITIZEN and playerGame.is_best
          profile.bestPlayerSheriff += 1 if playerGame.role == PLAYER_ROLES.SHERIFF and playerGame.is_best
          profile.bestPlayerMafia += 1 if playerGame.role == PLAYER_ROLES.MAFIA and playerGame.is_best
          profile.bestPlayerDon += 1 if playerGame.role == PLAYER_ROLES.DON and playerGame.is_best
          bestMoveAttempts += 1 if playerGame.took_best_move
          foundedMafiaOnBestMove += playerGame.best_move_accuracy if playerGame.took_best_move
          profile.firstKilledNightCitizen += 1 if playerGame.role == PLAYER_ROLES.CITIZEN and playerGame.is_killed_first_at_night
          profile.firstKilledNightSheriff += 1 if playerGame.role == PLAYER_ROLES.SHERIFF and playerGame.is_killed_first_at_night
          profile.firstKilledNightMafia += 1 if playerGame.role == PLAYER_ROLES.MAFIA and playerGame.is_killed_first_at_night
          profile.firstKilledNightDon += 1 if playerGame.role == PLAYER_ROLES.DON and playerGame.is_killed_first_at_night
          profile.firstKilledDayCitizen += 1 if playerGame.role == PLAYER_ROLES.CITIZEN and playerGame.is_killed_first_by_day
          profile.firstKilledDaySheriff += 1 if playerGame.role == PLAYER_ROLES.SHERIFF and playerGame.is_killed_first_by_day
          profile.firstKilledDayMafia += 1 if playerGame.role == PLAYER_ROLES.MAFIA and playerGame.is_killed_first_by_day
          profile.firstKilledDayDon += 1 if playerGame.role == PLAYER_ROLES.DON and playerGame.is_killed_first_by_day
          profile.foulsCitizen += playerGame.fouls if playerGame.role == PLAYER_ROLES.CITIZEN
          profile.foulsSheriff += playerGame.fouls if playerGame.role == PLAYER_ROLES.SHERIFF
          profile.foulsMafia += playerGame.fouls if playerGame.role == PLAYER_ROLES.MAFIA
          profile.foulsDon += playerGame.fouls if playerGame.role == PLAYER_ROLES.DON
        profile.bestMoveAccuracy = if bestMoveAttempts then foundedMafiaOnBestMove / bestMoveAttempts else 0.0
        profile.efficiency.sort((a, b)->
          return if a.date > b.date then 1 else -1
        )
        for i in [1...playerGames.length]
          profile.efficiency[i].winsMinusLosses += profile.efficiency[i - 1].winsMinusLosses
        done(null, profile)
      ).error(handleError)
    ).error(handleError)
  ).error(handleError)
