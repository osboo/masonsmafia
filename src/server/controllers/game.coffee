Player = require('../models/player')

module.exports = (app) ->
    app.post('/game', (req, res) ->
        user = req.user
        Player.createOrUpdate({id: 'foo', name: 'bar'})
        res.json({err: 'ok'})
    )
