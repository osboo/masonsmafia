Sequelize = require('sequelize')
db = require('./db')
PlayerGame = require('./player_game')
BestPlayerMarker = require('./best_player_marker')

Player = db.define('Player', {
    vk_id:
        type: Sequelize.STRING
        allowNull: false
    name:
        type: Sequelize.STRING
        allowNull: false
}, classMethods: {
    createFromProfile: (profile, callback) ->
        Player.create({
            vk_id: profile.id
            name: profile.displayName
        }).complete(callback)
})

Player.hasMany(PlayerGame, {foreignKey: 'player_id',  foreignKeyConstraint: true})
Player.hasMany(BestPlayerMarker, {foreignKey: 'player_id',  foreignKeyConstraint: true})

module.exports = Player
