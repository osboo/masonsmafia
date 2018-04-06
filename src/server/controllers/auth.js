passport = require('passport')
Vk = require('passport-vkontakte').Strategy
conf = require('../conf')('auth')

AUTH_URL = '/auth/vk'
AUTH_CALLBACK_URL = '/auth/callback'
HOME_PAGE = '/'

module.exports = (app) ->
    onProfileGot = (accessToken, refreshToken, profile, done) ->
      if profile.id in [688901]
        return done(null, profile)
      done('It is another user:(', null)

    passport.use('vk', new Vk({
        clientID: conf.id
        clientSecret: conf.secret
        callbackURL: AUTH_CALLBACK_URL
    }, onProfileGot))

    app.get(AUTH_URL, passport.authenticate('vk'))

    app.get(AUTH_CALLBACK_URL, passport.authenticate('vk', {
      failureRedirect: AUTH_URL
    }), (req, res)->
      res.redirect(req.session.returnTo || HOME_PAGE)
    )

    app.get('/logout', (req, res) ->
        req.logout()
        res.redirect(HOME_PAGE)
    )

    ensureAuthenticated = (req, res, next) ->
      if req.isAuthenticated() then next()
      else
        req.session.returnTo = req.url
        res.redirect(AUTH_URL)

    app.get('/admin', ensureAuthenticated, (req, res)->
        res.render('admin_index', {})
      )

    passport.serializeUser((user, done) ->
        done(null, user.id)
    )

    passport.deserializeUser((user, done) ->
        done(null, user)
    )
