Sequelize = require('sequelize')
db = require('./db')
PlayerGame = require('./player_game')

Game = db.define('Game', {
    date: {
      type: Sequelize.DATE,
      allowNull: false,
      defaultValue: Sequelize.NOW
    }

    result: {
      type: Sequelize.INTEGER,
      allowNull: false
    }

    first_killed_night: {
      type: Sequelize.INTEGER,
      references: "Player",
      referencesKey: "id"
    }

    first_killed_day: {
      type: Sequelize.INTEGER,
      allowNull: false
      references: "Player",
      referencesKey: "id"
    }

    best_move_author: {
      type: Sequelize.INTEGER,
      references: "Player",
      referencesKey: "id"
    }

    best_move_success: Sequelize.INTEGER
}, {
})

Game.hasMany(PlayerGame, {foreignKey: 'game_id', foreignKeyConstraint: true})

module.exports = Game
