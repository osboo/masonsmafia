require('./models/player')
require('./models/game')
require('./models/player_game')
require('./models/best_player_marker')
db = require('./models/db')

db.sync({force: true}).complete((err) ->
    console.error("Error while db sync #{err}") if err
    console.log("Sync done")
)
