// Generated by CoffeeScript 2.2.3
(function() {
  let conf = require('./conf')('app');
  let express = require('express');
  let passport = require('passport');
  let app = express();

  app.configure(function() {
    app.use(express.static(`${__dirname}/../static`));
    app.use(express.favicon());
    app.use(express.cookieParser());
    app.use(express.bodyParser());
    app.use(express.logger());
    app.use(express.session({
      secret: conf.sessionSecret,
    }));
    app.use(passport.initialize());
    app.use(passport.session());
    return app.use(app.router);
  });

  app.set('views', `${__dirname}/views`);

  app.set('view engine', 'jade');

  app.set('models', require('./models/db'));

  require('./controllers/index')(app);

  require('./controllers/auth')(app);

  require('./controllers/game')(app);

  (async function() {
    let err;
    try {
      await require('./models/RebuildCache')();
      return console.log('Cache rebuilt');
    } catch (error) {
      err = error;
      return console.error(`Rebuild cache failed ${err}`);
    }
  })();

  app.listen(conf.port);

  console.log(`Start listening ${conf.port}`);

  module.exports = app;
}).call(this); // eslint-disable-line no-invalid-this