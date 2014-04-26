models = {Game: null, Players: [], PlayerGames: []}

db = require('./db')
Sequelize = require('sequelize')

module.exports = (paper, done)->
  db.Game.create({
    result: paper.result
    date: paper.date
    referee: paper.referee
  }).success((game)->
    chainer = new Sequelize.Utils.QueryChainer
    for p in paper.players
      chainer.add(db.Player, 'findOrCreate', [{name: p.name}])

    chainer.runSerially().success((players)->
      chainer2 = new Sequelize.Utils.QueryChainer
      for p in paper.players
        chainer2.add(db.PlayerGame, 'create', [{
          role: p.role
          likes: p.likes
          fouls: p.fouls
          is_best: p.isBest
          extra_scores: p.extraScores
          took_best_move: if paper['bestMoveAuthor'] == p.name then true else false
          best_move_accuracy: if paper.bestMoveAuthor? && paper.bestMoveAuthor == p.name then paper.bestMoveAccuracy else 0
          is_killed_first_at_night: if paper['firstKilledAtNight'] == p.name then true else false
        }])

      chainer2.runSerially().success((playerGames)->
        chainer3 = new Sequelize.Utils.QueryChainer
        for i in [0...playerGames.length]
          chainer3.add(playerGames[i].setPlayer(players[i]))
          chainer3.add(playerGames[i].setGame(game))

        chainer3.run().success(()->
          models.Game = game
          models.Players = players
          models.PlayerGames = playerGames
          done(null, models))
        .error((err)->done(err, null))

      ).error((err)->done(err, null))
    ).error((err)->done(err, null))
  ).error((err)->done(err, null))
