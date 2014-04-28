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

    app.get('/all', (req, res)->
        setTimeout(
            ()->
                cached = require('./../common_stat_responce.json')
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
                cached = require('./../players.json')
                res.json(cached)
        , 2000
        )
    )

    app.get('/personal/maran', (req, res)->
        setTimeout(
            ()->
                cached = require('./../maran.json')
                res.json(cached)
        , 2000
        )
    )

    app.get('/admin', (req, res)->
      res.render('admin_index', {})
    )
