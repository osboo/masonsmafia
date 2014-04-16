Sequelize = require('sequelize')
db = require('./db')

PlayerGame = db.define('PlayerGame', {
    role:
        type: Sequelize.INTEGER
        allowNull: false
    fouls:
        type: Sequelize.INTEGER
        allowNull: false
        defaultValue: 0
    likes:
        type: Sequelize.INTEGER
        allowNull: false
        defaultValue: 0
    is_best:
        type: Sequelize.BOOLEAN
        defaultValue: false
    extra_scores:
        type: Sequelize.FLOAT
        defaultValue: 0.0
}, {
})

module.exports = PlayerGame
