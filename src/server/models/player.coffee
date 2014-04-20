SERVICE_ROLES = require('./constants').SERVICE_ROLES

module.exports = (db, Sequelize)->
  Player = db.define('Player', {
    vk_id:
        type: Sequelize.STRING

      name:
        type: Sequelize.STRING
        allowNull: false
        validate:
          notNull: true

    service_role:
        type: Sequelize.ENUM(SERVICE_ROLES.USER, SERVICE_ROLES.ADMIN)
        defaultValue: SERVICE_ROLES.USER
        allowNull: false
    },{
      associate: (models)->
        Player.hasMany(models.PlayerGame)
    }
  )

