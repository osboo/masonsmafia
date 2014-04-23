GAME_RESULT = require('./constants').GAME_RESULT

module.exports = (db, DataTypes)->
  Game = db.define('Game', {
    result:
      type: DataTypes.ENUM
      values: [GAME_RESULT.MAFIA_WIN, GAME_RESULT.CITIZENS_WIN]
      allowNull: false
      validate:
        notEmpty: true

    date:
      type: DataTypes.DATE
      allowNull: false
      validate:
        notNull: true

    referee:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notNull: true
    }, {
      associate: (models)->
        Game.hasMany(models.PlayerGame)
    }
  )
