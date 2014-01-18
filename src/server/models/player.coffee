Sequelize = require('sequelize')
db = require('./db')

Player = db.define('Player', {
    id: {type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true},
    vk_id: Sequelize.STRING,
    name: Sequelize.STRING
}, classMethods: {
    createFromProfile: (profile, callback) ->
        Player.create({
            vk_id: profile.id
            name: profile.displayName
        }).complete(callback)
})

module.exports = Player