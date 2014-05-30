modelBuilder = require('../models/BuildModels')
rebuildCache = require('../models/RebuildCache')

module.exports = (app) ->
    app.post('/game', (req, res) ->
      modelBuilder(req.body, (err, models)->
        if err
          res.status(500).send(["error occurred: #{err}"])
        else
          response = ["Игра сохранена"]
          response.push("Дата: #{models.Game.date}")
          response.push("Ведущий: #{models.Game.referee}")
          response.push("Победа: #{models.Game.result}")
          rebuildCache((err, top10)->
            if err
              res.status(500).send(["error occurred: #{err}"])
            else
              response.push("Cache rebuild")
              console.log(models.Players)
              res.status(200).send(response)
          )
      )
    )
