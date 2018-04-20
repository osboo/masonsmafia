// Generated by CoffeeScript 2.2.3
(function() {
  let modelBuilder, rebuildCache;

  modelBuilder = require('../models/BuildModels');

  rebuildCache = require('../models/RebuildCache');

  module.exports = function(app) {
    return app.post('/game', async function(req, res) {
      let err, models, response;
      try {
        models = (await modelBuilder(req.body));
        response = ['Игра сохранена'];
        response.push(`Дата: ${models.Game.date}`);
        response.push(`Ведущий: ${models.Game.referee}`);
        response.push(`Победа: ${models.Game.result}`);
        await rebuildCache();
        response.push('Cache rebuild');
        return res.status(200).send(response);
      } catch (error) {
        err = error;
        return res.status(500).send([`error occurred: ${err}`]);
      }
    });
  };
}).call(this); // eslint-disable-line no-invalid-this