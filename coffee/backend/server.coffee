#   Copyright (C) 2014 Greg Weston
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.

express = require 'express'
routes = require './routes'
config = require './config'
moment = require 'moment-timezone'

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

app.get '/', (req, res) =>
    today = moment().subtract(1, 'days').format('YYYY/M/D')
    res.redirect('/games/' + today)

app.use (req, res, next) ->
    res.status 404
    return res.render('404') if req.accepts 'html'
    return res.json({error: 'Not found'}) if req.accepts 'json'
    res.type('text').send('Not found')

app.listen 3030, ->
  console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env
