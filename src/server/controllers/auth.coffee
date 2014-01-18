passport = require('passport')
Vk = require('passport-vkontakte').Strategy
conf = require('../conf')('auth')

AUTH_URL = '/auth'
AUTH_CALLBACK_URL = '/auth/callback'

module.exports = (app) ->
    onProfileGot = (accessToken, refreshToken, profile, done) ->
        console.log 'profile', profile
        done(null, profile)

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

    passport.serializeUser((user, done) ->
        console.log 'ser', user
        done(null, user.id)
    )

    passport.deserializeUser((id, done) ->
        console.log 'deser', id
        done(null, {id})
    )
