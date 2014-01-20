passport = require('passport')
Vk = require('passport-vkontakte').Strategy
conf = require('../conf')('auth')
Player = require('../models/player')

AUTH_URL = '/auth'
AUTH_CALLBACK_URL = '/auth/callback'

module.exports = (app) ->
    onProfileGot = (accessToken, refreshToken, profile, done) ->
        Player.find({where: {vk_id: profile.id}}).complete((err, player) ->
            return done(err, null) if err
            return done(null, player) if player
            Player.createFromProfile(profile, done)
        )

    passport.use('vk', new Vk({
        clientID: conf.id
        clientSecret: conf.secret
        callbackURL: AUTH_CALLBACK_URL
    }, onProfileGot))

    app.get(AUTH_URL, passport.authenticate('vk'))

    app.get(AUTH_CALLBACK_URL, passport.authenticate('vk', {
        successRedirect: '/'
        failureRedirect: AUTH_URL
    }))

    app.get('/logout', (req, res) ->
        req.logout()
        res.redirect('/')
    )

    passport.serializeUser((user, done) ->
        done(null, user.id)
    )

    passport.deserializeUser((id, done) ->
        Player.find(id).complete(done)
    )
