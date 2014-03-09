module.exports = (app) ->
    app.get('/', (req, res) ->
        user = req.user
        viewName = 'anonymous_index'
        context = {}
        if user
            viewName = if user.isAdmin() then 'admin_index'
            context.user = user.values
        res.render(viewName, context)
    )

    app.get('/personal', (req, res) ->
        viewName = 'personal_statistics'
        context = {}
        res.render(viewName, context)
    )

    app.get('/dream', (req, res) ->
        viewName = 'dream_team'
        context = {}
        res.render(viewName, context)
    )
