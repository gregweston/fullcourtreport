express = require 'express'
routes = require './routes'
config = require './config'

app = module.exports = express.createServer();

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  
  
  app.use express.cookieParser config.cookieSecret
  app.use express.session({
    secret: config.cookieSecret
    cookie:
      path: '/'
      domain: app.settings.domain
      maxAge: 1000 * 60
  })
  
  app.use express.static(__dirname + '/public')
  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/data/games/:year/:month/:day/:away_team/:home_team', routes.gameData
app.get '/games/:year/:month/:day/:away_team/:home_team', routes.game
app.get '/games/:year/:month/:day', routes.day

app.get '/', routes.today, routes.day

app.use (req, res, next) ->
    res.status 404
    return res.render('404') if req.accepts 'html'
    return res.json({error: 'Not found'}) if req.accepts 'json'
    res.type('text').send('Not found')

app.listen 3030, ->
  console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env
