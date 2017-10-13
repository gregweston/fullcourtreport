const express = require('express');
const config = require('./config');
const ApiUrlBuilder = require('./ApiUrlBuilder');
const ApiRequest = require('./ApiRequest');

const app = express();

/*app.configure(function() {
  app.use(express.json());
  app.use(express.methodOverride());
  return app.use(app.router);
});*/

app.use(express.json());

/*app.configure('development', () => app.use(express.errorHandler({ dumpExceptions: true, showStack: true })));

app.configure('production', () => app.use(express.errorHandler()));*/

app.get('/api/date/:year/:month/:day', (req, res) => {
	const url = ApiUrlBuilder.gamesForDayUrl(req.params.year, req.params.month, req.params.day);
	const request = new ApiRequest(url, config);
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
