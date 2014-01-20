module.exports = (app) ->
    app.get('/', (req, res) ->
        user = req.user
        viewName = 'anonymous_index'
        if user
            viewName = if user.isAdmin() then 'admin_index' else 'logged_index'
        res.render(viewName)
    )
