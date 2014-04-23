PLAYER_ROLES = require('./constants').PLAYER_ROLES

module.exports = (db, Sequelize)->
  PlayerGame = db.define('PlayerGame', {
    role:
      type: Sequelize.ENUM
      values: [PLAYER_ROLES.CITIZEN, PLAYER_ROLES.SHERIFF, PLAYER_ROLES.MAFIA, PLAYER_ROLES.DON]
      allowNull: false
      validate:
        notEmpty: true

    fouls:
      type: Sequelize.INTEGER
      allowNull: false
      defaultValue: 0
      max: 4

    likes:
      type: Sequelize.INTEGER
      allowNull: false
      defaultValue: 0

    is_best:
      type: Sequelize.BOOLEAN
      defaultValue: false

    is_killed_first_at_night:
      type: Sequelize.BOOLEAN
      defaultValue: false

    is_killed_first_by_day:
      type: Sequelize.BOOLEAN
      defaultValue: false

    took_best_move:
      type: Sequelize.BOOLEAN
      defaultValue: false

    best_move_accuracy:
      type: Sequelize.INTEGER
      defaultValue: 0
      min: 0
      max: 3

    extra_scores:
      type: Sequelize.FLOAT
      defaultValue: 0.0
    },{
      associate: (models)->
        PlayerGame.belongsTo(models.Game)
        PlayerGame.belongsTo(models.Player)
    }
  )
