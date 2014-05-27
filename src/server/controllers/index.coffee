require('string_decoder').StringDecoder

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
        if req.query.name == "Maran"
          cached = require('./../maran.json')
          res.json(cached)
        else
          res.status(404).send("Not found")
    )

    app.get('/admin', (req, res)->
      res.render('admin_index', {})
    )
