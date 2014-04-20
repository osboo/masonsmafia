db = require('./models/db')

db.sequelize.sync({force: true}).complete((err) ->
    console.error("Error while db sync #{err}") if err
    console.log("Sync done")
)
