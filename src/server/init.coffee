config = require('./conf')('db')
Sequelize = require('sequelize')
db = require('./models/db')

createSchema = (db)->
    try
        await db.sequelize.authenticate()
        await db.sequelize.sync({force: true})
        console.log("Sync done")
    catch err
        console.error("Error while db sync #{err}")

attemptToCreateSchema = (done)->
    try
        await db.sequelize.authenticate()
        console.log('Connected, creating schema..')
        createSchema(db)
        done()
    catch err
        console.error("#{err}") 
        console.log("Attempt to create database and user from scratch...")
        initConnection = new Sequelize("mysql", "root", "#{process.env.MYSQL_ROOT_PASSWORD}", {
            host: config.host,
            dialect: 'mysql',
            logging: false
        })

        await initConnection.query("CREATE DATABASE IF NOT EXISTS #{config.dbName};")
        console.log("Database #{config.dbName} created")
        await initConnection.query("GRANT ALL PRIVILEGES ON #{config.dbName}.* TO '#{config.login}'@'%' IDENTIFIED BY '#{config.password}';")
        console.log("User #{config.login} created")
        await initConnection.query("FLUSH PRIVILEGES;")
        createSchema(db)
        done()

do init = ()->
    try
        p = new Promise((resolve, reject)->
            timerId = setInterval( ()->
                try
                    await attemptToCreateSchema(resolve)
                    clearInterval(timerId)
                catch err
                    console.log("Failed attempt: #{err}")
            , 10000)

            setTimeout(()->
                clearInterval(timerId)
                reject("Cannot rebuild in 60 sec")
            , 60000)
        )
        await p
    catch err
        console.log("#{err}")

