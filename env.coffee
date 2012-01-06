# modules

express = require('express')


# template helpers

helpers = {
  css: (attrs) ->
    return text global.css(attrs)
  js: (attrs) ->
    return text global.js(attrs)
}


# setup

module.exports = (app, express) ->

  app.configure () ->
    app.set('views', __dirname + '/views')
    # template settings
    app.set('view engine', 'coffee')
    app.set('view options', {layout:false, hardcode:helpers, format:true})
    app.register('.coffee', require('coffeekup').adapters.express)
    # other settings
    app.use(express.bodyParser())
    app.use(express.cookieParser())
    app.use(express.methodOverride())
    app.use(app.router)
    app.use(express.static(__dirname + '/public'))
    app.use(require('connect-assets')())


  app.configure 'development', () ->
    app.use(express.errorHandler({dumpExceptions:true, showStack:true}))


  app.configure 'production', () ->
    app.use(express.errorHandler())
