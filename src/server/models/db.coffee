Sequelize = require('sequelize')
conf = require('../conf')('db')

module.exports = new Sequelize(conf.dbName, conf.login, conf.password, {
    host: conf.host
    dialect: 'mysql'
})
