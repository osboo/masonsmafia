fs = require('fs')
path = require('path')
Sequelize = require('sequelize')
config = require('../conf')('db')
lodash = require('lodash')

connection = new Sequelize(config.dbName, config.login, config.password, {
    host: config.host
    dialect: 'mysql'
})

models = {}

notModels = ['BuildModels.js', 'constants.js']

fs.readdirSync(__dirname).filter(
  (file)->
    ((file.indexOf('.') != 0) && (file not in notModels) && (file.slice(-3) == '.js'))
).forEach(
  (file)->
    try
      model = connection.import(path.join(__dirname, file))
      models[model.name] = model
    catch err

)

Object.keys(models).forEach((modelName)->
  if models[modelName].options.hasOwnProperty('associate')
    models[modelName].options.associate(models)
)

module.exports = lodash.extend({
  sequelize: connection,
}, models)