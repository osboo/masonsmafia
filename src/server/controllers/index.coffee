computerPersonal = require('../models/ComputePersonal')

module.exports = (app) ->
    app.get('/', (req, res) ->
        viewName = 'common_statistics'
        context = {}
        res.render(viewName, context)
    )

    app.get('/personal', (req, res) ->
        viewName = 'personal_statistics'
        context = {}
        res.render(viewName, context)
    )
    
    app.get('/personal/:name', (req, res) ->
        viewName = 'personal_statistics'
        context = {'name': req.params.name}
        res.render(viewName, context)
    )

    app.get('/personal_stat', (req, res)->
        try
            profile = await computerPersonal(req.query.name)
            res.json(profile)
        catch error
            res.status(404).send(JSON.stringify(error))
    )

    app.get('/help', (req, res)->
      res.render('help', {})
    )
