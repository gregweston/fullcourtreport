const express = require('express');
const config = require('./config');
const DataUrlBuilder = require('./DataUrlBuilder');
const DataRequest = require('./DataRequest');

const app = express();

/*app.configure(function() {
  app.use(express.json());
  app.use(express.methodOverride());
  return app.use(app.router);
});*/

app.use(express.json());

/*app.configure('development', () => app.use(express.errorHandler({ dumpExceptions: true, showStack: true })));

app.configure('production', () => app.use(express.errorHandler()));*/

app.get('/api/games-on-date', (req, res) => {
	const url = DataUrlBuilder.gamesForDayUrl(req.query.year, req.query.month, req.query.day);
	const request = new DataRequest(url, config);
	request.send((err, response) => {
		console.log(response);
		res.send(response);
	});
});

app.get('/api/game/:year/:month/:day/:awayTeam/:homeTeam', () => {

});

app.use(function(req, res, next) {
    res.status(404);
    if (req.accepts('html')) { return res.render('404'); }
    if (req.accepts('json')) { return res.json({error: 'Not found'}); }
    return res.type('text').send('Not found');
});

app.listen(3030, () => console.log('Express server listening on port 3030 in %s mode', app.settings.env));
