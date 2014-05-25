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

    app.get('/all', (req, res)->
        setTimeout(
            ()->
                cached = require('./../../static/common_stat_responce.json')
                res.json(cached)
        , 2000
        )
    )

    app.get('/top-10', (req, res)->
        setTimeout(
            ()->
                cached = require('./../top10.json')
                res.json(cached)
        , 2000
        )
    )

    app.get('/players', (req, res)->
        setTimeout(
            ()->
                cached = require('./../../static/players.json')
                res.json(cached)
        , 2000
        )
    )

    app.get('/personal_stat', (req, res)->
        if req.query.name == "Maran"
            setTimeout(
                ()->
                    cached = require('./../maran.json')
                    res.json(cached)
            , 2000
            )
        else
            res.status(404).send("Not found")
    )

    app.get('/admin', (req, res)->
      res.render('admin_index', {})
    )
