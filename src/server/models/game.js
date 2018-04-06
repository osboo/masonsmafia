/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const { GAME_RESULT } = require('./constants');

module.exports = function(db, DataTypes){
  let Game;
  return Game = db.define('Game', {
    result: {
      type: DataTypes.ENUM,
      values: [GAME_RESULT.MAFIA_WIN, GAME_RESULT.CITIZENS_WIN],
      allowNull: false
    },

    date: {
      type: DataTypes.DATE,
      allowNull: false
    },

    referee: {
      type: DataTypes.STRING,
      allowNull: false
    }
    }, {
      associate(models){
        return Game.hasMany(models.PlayerGame);
      },
      charset: 'utf8',
      collate: 'utf8_unicode_ci'
    }
  );
};
