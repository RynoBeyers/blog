# modules

express = require('express')
app = module.exports = express.createServer()

require('./env.coffee')(app, express)


# routes

app.get '/', (req, res) ->
  res.render 'index'

app.get '/register', (req, res) ->
  res.render 'register'


# server

app.listen(3000)
console.log("Server Running...")
