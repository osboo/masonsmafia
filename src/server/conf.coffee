conf =
    app:
        port: 3000
        sessionSecret: 'as9a9waiodnla21&&7aajwTaw7('
        storeOptions:
            db: 2
    auth:
        id: '4128469'
        secret: '5fPfSkh0MZGUMPd15F3y'
    db:
        dbName: 'masons'
        login: 'masons'
        password: 'masons'
        host: 'localhost'


module.exports = (section) ->
    return conf[section]