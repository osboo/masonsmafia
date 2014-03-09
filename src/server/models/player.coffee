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
    createOrUpdate: (profile, callback) ->
        query = """
            INSERT INTO Players
            (vk_id, name) VALUES(:id, :name)
            ON DUPLICATE KEY UPDATE vk_id=:id, name=:name
        """
        placeholders =
            id: profile.id
            name: profile.name
        db.query(query, null, {raw: true}, placeholders).success((err, data) ->
            console.log("111", err, data)
        )
}, instanceMethods: {
    isAdmin: () ->
        return @service_role == SERVICE_ROLES.ADMIN
})

Player.hasMany(PlayerGame, {foreignKey: 'player_id',  foreignKeyConstraint: true})
Player.hasMany(BestPlayerMarker, {foreignKey: 'player_id',  foreignKeyConstraint: true})

module.exports = Player
