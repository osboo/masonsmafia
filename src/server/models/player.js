// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const { SERVICE_ROLES } = require('./constants');

module.exports = function(db, DataTypes){
  let Player;
  return Player = db.define('Player', {
    vk_id: {
        type: DataTypes.STRING
      },

    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },

    service_role: {
        type: DataTypes.ENUM(SERVICE_ROLES.USER, SERVICE_ROLES.ADMIN),
        defaultValue: SERVICE_ROLES.USER,
        allowNull: false
      }
    },{
      associate(models){
        return Player.hasMany(models.PlayerGame);
      },
      charset: 'utf8',
      collate: 'utf8_unicode_ci'
    }
  );
};

