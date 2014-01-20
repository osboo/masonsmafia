Sequelize = require('sequelize')
db = require('./db')

PlayerGame = db.define('PlayerGame', {
    role: Sequelize.INTEGER
    fall_count: Sequelize.INTEGER
    like_count: Sequelize.INTEGER
}, {
})

module.exports = PlayerGame
