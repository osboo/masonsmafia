// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const passport = require('passport');
const Vk = require('passport-vkontakte').Strategy;
const conf = require('../conf')('auth');

const AUTH_URL = '/auth/vk';
const AUTH_CALLBACK_URL = '/auth/callback';
const HOME_PAGE = '/';

module.exports = function(app) {
    const onProfileGot = function(accessToken, refreshToken, profile, done) {
      if ([688901].includes(profile.id)) {
        return done(null, profile);
      }
      return done('It is another user:(', null);
    };

    passport.use('vk', new Vk({
        clientID: conf.id,
        clientSecret: conf.secret,
        callbackURL: AUTH_CALLBACK_URL,
    }, onProfileGot));

    app.get(AUTH_URL, passport.authenticate('vk'));

    app.get(AUTH_CALLBACK_URL, passport.authenticate('vk', {
      failureRedirect: AUTH_URL,
    }), (req, res)=> res.redirect(req.session.returnTo || HOME_PAGE));

    app.get('/logout', function(req, res) {
        req.logout();
        return res.redirect(HOME_PAGE);
    });

    const ensureAuthenticated = function(req, res, next) {
      if (req.isAuthenticated()) {
 return next();
      } else {
        req.session.returnTo = req.url;
        return res.redirect(AUTH_URL);
      }
    };

    app.get('/admin', ensureAuthenticated, (req, res)=> res.render('admin_index', {}));

    passport.serializeUser((user, done) => done(null, user.id));

    return passport.deserializeUser((user, done) => done(null, user));
  };
