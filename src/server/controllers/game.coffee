modelBuilder = require('../models/BuildModels')
rebuildCache = require('../models/RebuildCache')

module.exports = (app) ->
  app.post('/game', (req, res) ->
    try
      models = await modelBuilder(req.body)
      response = ["Игра сохранена"]
      response.push("Дата: #{models.Game.date}")
      response.push("Ведущий: #{models.Game.referee}")
      response.push("Победа: #{models.Game.result}")
      [top10, common] = await rebuildCache()
      response.push("Cache rebuild")
      res.status(200).send(response)
    catch err
      res.status(500).send(["error occurred: #{err}"])
  )
