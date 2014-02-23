Sequelize = require('sequelize')
db = require('./db')

PlayerGame = db.define('PlayerGame', {
    role:
        type: Sequelize.INTEGER
        allowNull: false
    fall_count:
        type: Sequelize.INTEGER
        allowNull: false
        defaultValue: 0
    like_count:
        type: Sequelize.INTEGER
        allowNull: false
        defaultValue: 0
    isFirstKilledNight:
        type: Sequelize.BOOLEAN
        defaultValue: false
    isFirstKilledDay:
        type: Sequelize.BOOLEAN
        defaultValue: false
}, {
})

module.exports = PlayerGame
