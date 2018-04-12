// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const {PLAYER_ROLES} = require('./constants');

module.exports = function(db, Sequelize) {
  let PlayerGame;
  return PlayerGame = db.define('PlayerGame', {
    role: {
      type: Sequelize.ENUM,
      values: [PLAYER_ROLES.CITIZEN, PLAYER_ROLES.SHERIFF, PLAYER_ROLES.MAFIA, PLAYER_ROLES.DON],
      allowNull: false,
    },

    fouls: {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 0,
      max: 4,
    },

    likes: {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 0,
    },

    is_best: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },

    is_killed_first_at_night: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },

    is_killed_first_by_day: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },

    took_best_move: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },

    best_move_accuracy: {
      type: Sequelize.INTEGER,
      defaultValue: 0,
      min: 0,
      max: 3,
    },

    extra_scores: {
      type: Sequelize.FLOAT,
      defaultValue: 0.0,
    },
    }, {
      associate(models) {
        PlayerGame.belongsTo(models.Game);
        return PlayerGame.belongsTo(models.Player);
      },
      charset: 'utf8',
      collate: 'utf8_unicode_ci',
    }
  );
};
