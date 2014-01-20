Sequelize = require('sequelize')
db = require('./db')
PlayerGame = require('./player_game')
BestPlayerMarker = require('./best_player_marker')
SERVICE_ROLES = require('./constants').SERVICE_ROLES

Player = db.define('Player', {
    vk_id:
        type: Sequelize.STRING
        allowNull: false
    name:
        type: Sequelize.STRING
        allowNull: false
    service_role:
        type: Sequelize.ENUM(SERVICE_ROLES.USER, SERVICE_ROLES.ADMIN)
        defaultValue: SERVICE_ROLES.USER

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
