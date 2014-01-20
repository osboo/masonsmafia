Sequelize = require('sequelize')
db = require('./db')
PlayerGame = require('./player_game')
BestPlayerMarker = require('./best_player_marker')

Game = db.define('Game', {
    date: Sequelize.DATE
    result: Sequelize.INTEGER
}, {
})

Game.hasMany(PlayerGame, {foreignKey: 'game_id', foreignKeyConstraint: true})
Game.hasMany(BestPlayerMarker, {foreignKey: 'game_id', foreignKeyConstraint: true})

module.exports = Game
