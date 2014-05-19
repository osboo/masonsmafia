db = require('./db')
Sequelize = require('sequelize')

module.exports = (done)->
  db.Player.all().success((players)->
    chainer = new Sequelize.Utils.QueryChainer
    for player in players
      chainer.add(db.PlayerGame.findAll({where: {PlayerId: player.id}}))

    chainer.run()
    .success((playerHistories)->
      done(null, playerHistories)
    ).error((err)->
      done(err, null)
    )
  ).error((err)->
    done(err, null)
  )