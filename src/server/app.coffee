express = require('express')
passport = require('passport')
conf = require('./conf')('app')

app = express()
app.configure(() ->
    app.use(express.static("#{__dirname}/../static"))
    app.use(express.favicon())
    app.use(express.cookieParser())
    app.use(express.bodyParser())
    app.use(express.logger())
    app.use(express.session({secret: conf.sessionSecret}))
    app.use(passport.initialize());
    app.use(passport.session());
    app.use(app.router)
)
app.set('views', "#{__dirname}/views")
app.set('view engine', 'jade')

app.set('models', require('./models/db'))

require('./controllers/index')(app)
require('./controllers/auth')(app)
require('./controllers/game')(app)
do ()->
  try
    await require('./models/RebuildCache')()
    console.log('Cache rebuilt')
  catch err
    console.error("Rebuild cache failed #{err}")

app.listen(conf.port)
console.log("Start listening #{conf.port}")

module.exports = app