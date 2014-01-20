Sequelize = require('sequelize')
db = require('./db')
PlayerGame = require('./player_game')
BestPlayerMarker = require('./best_player_marker')

Game = db.define('Game', {
    date:
        type: Sequelize.DATE
        allowNull: false
        defaultValue: Sequelize.NOW
    result: Sequelize.INTEGER
}, {
})

Game.hasMany(PlayerGame, {foreignKey: 'game_id', foreignKeyConstraint: true})
Game.hasMany(BestPlayerMarker, {foreignKey: 'game_id', foreignKeyConstraint: true})

module.exports = Game
