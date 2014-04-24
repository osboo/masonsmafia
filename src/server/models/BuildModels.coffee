models = {Game: null, Players: [], PlayerGames: []}

db = require('./db')
events = require('events')

tryToComplete = (modelPart, done)->
  if modelPart.Game && modelPart.Players.length == 10 && modelPart.PlayerGames.length == 10
    done(modelPart)

createPlayerGame = (record, game, done)->
  p = record
  playerModel = db.Player
  playerGameModel = db.PlayerGame
  playerGameModel.create({
    role: p.role
    fouls: p.fouls
    likes: p.likes
    is_best: p.isBest
    extra_scores: p.extraScores
  }).success((newPlayerGame)->
    playerModel.findOrCreate({name: p.name}).success((newPlayer)->
      models.Players.push(newPlayer)
      newPlayerGame.setPlayer(newPlayer)
      newPlayerGame.setGame(game)
      models.PlayerGames.push(newPlayerGame)
      tryToComplete(models, done)
    ).error((err)->done(err))
  ).error((err)->done(err))

module.exports = (paper, done)->
  db.Game.create({
    result: paper.result
    date: paper.date
    referee: paper.referee
  }).success((game)->
    models.Game = game
    tryToComplete(models, done)
    for p in paper.players
      createPlayerGame(p, game, done)
  ).error((err)->
    done(err)
  )

