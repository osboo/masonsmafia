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
      computerPersonal(req.query.name, (error, profile)->
        if error
          res.status(404).send(JSON.stringify(error))
        else
          res.json(profile)
      )
    )

    app.get('/admin', (req, res)->
      res.render('admin_index', {})
    )
