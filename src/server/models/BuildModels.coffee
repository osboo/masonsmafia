models = {Game: null, Players: [], PlayerGames: []}

db = require('./db')
fs = require('fs')
Sequelize = require('sequelize')

buildModelsAsync = (paper, done)->
  try
    game = await db.Game.create({
      result: paper.result
      date: paper.date
      referee: paper.referee
    })

    players = (await db.Player.findOrCreate({where: {name: p.name}}).spread((player, wasCreated)->player) for p in paper.players )

    chainer2 = new Sequelize.Utils.QueryChainer
    playerGames = []
    for p in paper.players
      pg = await db.PlayerGame.create({
        role: p.role
        likes: p.likes
        fouls: p.fouls
        is_best: p.isBest
        extra_scores: p.extraScores
        took_best_move: if paper['bestMoveAuthor'] == p.name then true else false
        best_move_accuracy: if paper.bestMoveAuthor? && paper.bestMoveAuthor == p.name then paper.bestMoveAccuracy else 0
        is_killed_first_at_night: if paper['firstKilledAtNight'] == p.name then true else false
        is_killed_first_by_day: if paper['firstKilledByDay'] == p.name then true else false
      })
      playerGames.push(pg)

    for i in [0...playerGames.length]
      await playerGames[i].setGame(game)
      await playerGames[i].setPlayer(players[i])
    
    models.Game = game
    models.Players = players
    models.PlayerGames = playerGames
    dumpPaper = ()->
      new Promise( (resolve, reject)->
        fs.writeFile('paper.json', JSON.stringify(paper, null, 4), (err)->
          reject(err) if err
          resolve(paper) if not err
        )
      )
    await dumpPaper()
    done(null, models)
  catch err
    done(err, null)

module.exports = (paper) ->
  new Promise( (resolve, reject) ->
    buildModelsAsync(paper, (err, models)->
      reject(err) if err
      resolve(models) if not err
    )
  )