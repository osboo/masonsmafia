models = {Game: null, Players: [], PlayerGames: []}

db = require('./db')
events = require('events')

tryToComplete = (modelPart, done)->
  if modelPart.Game && modelPart.Players.length == 10 && modelPart.PlayerGames.length == 10
    done(modelPart)

module.exports = (paper, done)->
  db.Game.create({
    result: paper.result
    date: paper.date
    referee: paper.referee
  }).success((game)->
    models.Game = game
    tryToComplete(models, done)
  ).error((err)->
    done(err)
  )

  playerModel = db.Player
  playerGameModel = db.PlayerGame
  for p in paper.players
    events.on('playerGameCreate', (whatever)->
      playerModel.findOrCreate({name: p.name}).success((newPlayer)->
        models.Players.push(newPlayer)
        # newPlayerGame.setPlayer(newPlayer)
        # newPlayerGame.setGame(models.Game)
        models.PlayerGames.push(newPlayerGame)
        tryToComplete(models, done)
      ).error((err)->done(err))
    )

    playerGameModel.create({
      role: p.role
      fouls: p.fouls
      likes: p.likes
      is_best: p.isBest
      extra_scores: p.extraScores
    }).success((newPlayerGame)->
      events.emit('playerGameCreate')
    ).error((err)->done(err))
