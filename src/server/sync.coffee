db = require('./models/db')

db.sequelize.authenticate().complete((err)->
  if err
    console.error("Cannot connect #{err}")
  else
    console.log('Connected')
)

db.sequelize.sync({force: true}).complete((err) ->
    console.error("Error while db sync #{err}") if err
    console.log("Sync done")
)
