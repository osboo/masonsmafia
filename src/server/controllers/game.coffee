modelBuilder = require('../models/BuildModels')

module.exports = (app) ->
    app.post('/game', (req, res) ->
      modelBuilder(req.body, (err, models)->
        if err
          res.status(500).send(["error occured: #{err}"])
        else
          response = ["Игра сохранена"]
          response.push("Дата: #{models.Game.date}")
          response.push("Ведущий: #{models.Game.referee}")
          response.push("Победа: #{models.Game.result}")
          res.status(200).send(response)
      )
    )
