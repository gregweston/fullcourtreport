/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const express = require('express');
const routes = require('./routes');
const config = require('./config');
const moment = require('moment-timezone');

const app = (module.exports = express.createServer());

app.configure(function() {
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());


  app.use(express.cookieParser(config.cookieSecret));
  app.use(express.session({
    secret: config.cookieSecret,
    cookie: {
      path: '/',
      domain: app.settings.domain,
      maxAge: 1000 * 60
    }
  })
  );

  app.use(express.static(__dirname + '/public'));
  return app.use(app.router);
});

app.configure('development', () => app.use(express.errorHandler({ dumpExceptions: true, showStack: true })));

app.configure('production', () => app.use(express.errorHandler()));

app.get('/data/games/:year/:month/:day/:away_team/:home_team', routes.gameData);
app.get('/games/:year/:month/:day/:away_team/:home_team', routes.game);
app.get('/games/:year/:month/:day', routes.day);

app.get('/', (req, res) => {
    const today = moment().subtract(1, 'days').format('YYYY/M/D');
    return res.redirect(`/games/${today}`);
});

app.use(function(req, res, next) {
    res.status(404);
    if (req.accepts('html')) { return res.render('404'); }
    if (req.accepts('json')) { return res.json({error: 'Not found'}); }
    return res.type('text').send('Not found');
});

app.listen(3030, () => console.log('Express server listening on port %d in %s mode', app.address().port, app.settings.env));
