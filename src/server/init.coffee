config = require('./conf')('db')
Sequelize = require('sequelize')
db = require('./models/db')

connection = new Sequelize(config.dbName, config.login, config.password, {
    host: config.host,
    dialect: 'mysql',
    logging: false
})

createSchema = (db)->
    db.sequelize.authenticate().complete((err)->
        db.sequelize.sync({force: true}).complete((err) ->
            console.error("Error while db sync #{err}") if err
            console.log("Sync done")
            true
        )
    )

connection.authenticate().complete((err)->
  if err
    console.error("#{err} \n Attempt to create database and user from scratch...")

    initConnection = new Sequelize("mysql", "root", "#{process.env.MYSQL_ROOT_PASSWORD}", {
        host: config.host,
        dialect: 'mysql',
        logging: false
    })

    initConnection.query("CREATE DATABASE IF NOT EXISTS #{config.dbName};").then(()-> 
        console.log("Database #{config.dbName} created")
        initConnection.query("GRANT ALL PRIVILEGES ON #{config.dbName}.* TO '#{config.login}'@'%' IDENTIFIED BY '#{config.password}';").then(()-> 
            console.log("User #{config.login} created")
            initConnection.query("FLUSH PRIVILEGES;").then(()->createSchema(db))
        )
    )
  else
    console.log('Connected, creating schema..')
    createSchema(db)
)