doctype 5
html ->
    head ->
        title "Masons mafia stat app"
        meta charset: 'utf-8', name: 'viewport', content: 'width=device-width, initial-scale=1.0'
        link rel: 'stylesheet', href: '/css/bootstrap.css'
        link rel: 'stylesheet', href: '/css/app.css'
        script src: '/js/jquery.js'
        script src: '/js/bootstrap.js'
        script src: '/js/app.js'
        ie 'lt IE9', ->
            script src: 'https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js'
            script src: 'https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js'
    body ->
        div '.container', ->
           'welcome to app'
        a href: '/auth', 'Vkontakte'
