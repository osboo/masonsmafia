models = {Game: null, Players: [], PlayerGames: []}

db = require('./db')
events = require('events')

module.exports = (paper, done)->
  db.Game.create({
    result: paper.result
    date: paper.date
    referee: paper.referee
  }).success((game)->
    models['Game'] = game
    done(models)
  ).error((err)->
    done(err)
  )

#  models['Players'] = []
#  models['PlayerGame'] = []
#  playerModel = db.Player
#  playerGame = db.PlayerGame
#  for p in paper.players
#    player = null
#    playerModel.findOrCreate({name: p.name}).success((newPlayer, isCreated)->
#      player = newPlayer
#    )

#    playerGame.create({
#      role: p.role
#      fouls: p.fouls
#      likes: p.likes
#      is_best: p.isBest
#      extra_scores: p.extraScores
#    }).success((newPlayerGame)->
#      models['PlayerGame'].push(newPlayerGame)
#    )
  models
