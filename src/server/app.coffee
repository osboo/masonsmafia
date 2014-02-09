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
    app.use(express.session({ secret: conf.sessionSecret}));
    app.use(passport.initialize());
    app.use(passport.session());
    app.use(app.router)
)
app.set('views', "#{__dirname}/views")
app.set('view engine', 'jade')

require('./controllers/index')(app)
require('./controllers/auth')(app)

app.listen(conf.port)
console.log("Start listening #{conf.port}")

module.exports = app