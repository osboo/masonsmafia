GAME_RESULT = require('./constants').GAME_RESULT

module.exports = (db, DataTypes)->
  Game = db.define('Game', {
    result: {
      type: DataTypes.ENUM,
      values: [GAME_RESULT.MAFIA_WIN, GAME_RESULT.CITIZENS_WIN]
      allowNull: false
    }

    date: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW
    }}, {
      associate: (models)->
        Game.hasMany(models.PlayerGame)
    }
  )
