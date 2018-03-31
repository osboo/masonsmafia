models = {Game: null, Players: [], PlayerGames: []}

db = require('./db')
fs = require('fs')
Sequelize = require('sequelize')

module.exports = (paper, done)->
  try
    game = await db.Game.create({
      result: paper.result
      date: paper.date
      referee: paper.referee
    })

    chainer = new Sequelize.Utils.QueryChainer
    for p in paper.players
      chainer.add(db.Player, 'findOrCreate', [{where: {name: p.name}}])

    players = await chainer.runSerially()

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
        is_killed_first_by_day: if paper['firstKilledByDay'] == p.name then true else false
      }])

    playerGames = await chainer2.runSerially()
    
    chainer3 = new Sequelize.Utils.QueryChainer
    for i in [0...playerGames.length]
      chainer3.add(playerGames[i].setGame(game))
      chainer3.add(playerGames[i].setPlayer(players[i]))

    await chainer3.run()

    models.Game = game
    models.Players = players
    models.PlayerGames = playerGames
    fs.writeFile('paper.json', JSON.stringify(paper, null, 4), -> )
    done(null, models)
  catch error
    done(error, null)
