GAME_RESULT = require('./constants').GAME_RESULT

module.exports = (db, DataTypes)->
  Game = db.define('Game', {
    result:
      type: DataTypes.ENUM
      values: [GAME_RESULT.MAFIA_WIN, GAME_RESULT.CITIZENS_WIN]
      allowNull: false

    date:
      type: DataTypes.DATE
      allowNull: false

    referee:
      type: DataTypes.STRING
      allowNull: false
    }, {
      associate: (models)->
        Game.hasMany(models.PlayerGame)
      charset: 'utf8',
      collate: 'utf8_unicode_ci'
    }
  )
