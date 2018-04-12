// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');
const config = require('../conf')('db');
const lodash = require('lodash');

const connection = new Sequelize(config.dbName, config.login, config.password, {
    host: config.host,
    dialect: 'mysql',
    logging: false,
    dialectOptions: {
     charset: 'utf8_unicode_ci',
  },
});

const models = {};

const modelsFiles = ['game.js', 'player.js', 'player_game.js'];

fs.readdirSync(__dirname).filter(
  (file)=> (file.indexOf('.') !== 0) && (Array.from(modelsFiles).includes(file)) && (file.slice(-3) === '.js')).forEach(
  function(file) {
      const model = connection.import(path.join(__dirname, file));
      return models[model.name] = model;
});

Object.keys(models).forEach(function(modelName) {
  if (models[modelName].options.hasOwnProperty('associate')) {
    return models[modelName].options.associate(models);
  }
});

module.exports = lodash.extend({
  sequelize: connection,
}, models);
