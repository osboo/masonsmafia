module.exports = (app) ->
    app.get('/', (req, res) ->
        user = req.user
        viewName = 'anonymous_index'
        context = {}
        if user
            viewName = if user.isAdmin() then 'logged_index' else 'logged_index'
            context.user = user.values
        res.render(viewName, context)
    )
