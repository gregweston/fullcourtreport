const express = require('express');
const config = require('./config');
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

app.get('/api/games', (req, res) => {
	const url = '/events.json?date=' + req.query.date + '&sport=nba';
	const dataRequest = new DataRequest(url, config);
	dataRequest.send((err, response) => {
		console.log(response);
		res.send(response);
	});
});

app.get('/api/box-score', (req, res) => {
	const url = "/nba/boxscore/" + req.query.gameId + ".json";
	const dataRequest = new DataRequest(url, config);
	dataRequest.send((err, response) => {
		console.log(response);
		res.send(response);
	});
});

app.get('/api/team-stats', (req, res) => {
	const url = "/nba/team-stats/" + req.query.date + ".json?team_id=" + req.query.teamId;
	const dataRequest = new DataRequest(url, config);
	dataRequest.send((err, response) => {
		console.log(response);
		res.send(response);
	});
});

app.use(function(req, res, next) {
    res.status(404);
    if (req.accepts('json')) { return res.json({error: 'Not found'}); }
    return res.type('text').send('Not found');
});

app.listen(3030, () => console.log('Express server listening on port 3030 in %s mode', app.settings.env));
