SERVICE_ROLES = require('./constants').SERVICE_ROLES

module.exports = (db, DataTypes)->
  Player = db.define('Player', {
    vk_id:
        type: DataTypes.STRING

    name:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notNull: true

    service_role:
        type: DataTypes.ENUM(SERVICE_ROLES.USER, SERVICE_ROLES.ADMIN)
        defaultValue: SERVICE_ROLES.USER
        allowNull: false
    },{
      associate: (models)->
        Player.hasMany(models.PlayerGame)
    }
  )

