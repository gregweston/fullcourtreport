const express = require('express');
const config = require('./config');
const DataRequest = require('./DataRequest');
const moment = require('moment');

const app = express();

app.use(express.json());

app.get('/api/games', (req, res) => {
	const url = '/events.json?date=' + req.query.date + '&sport=nba';
	const dataRequest = new DataRequest(url, config);
	dataRequest.send((err, response) => {
		if (err) {
			res.status(err).send();
			return;
		}
		res.send(response);
	});
});

app.get('/api/box-score', (req, res) => {
	const url = "/nba/boxscore/" + req.query.gameId + ".json";
	const dataRequest = new DataRequest(url, config);
	dataRequest.send((err, response) => {
		if (err) {
			res.status(err).send();
			return;
		}
		res.send(response);
	});
});

app.get('/api/team-stats', (req, res) => {
	const date = moment(req.query.date, "YYYYMMDD");
	const month = date.format("M");
	let seasonEndYear;
	let seasonEndDateString;
	if (month >= 10) {
		seasonEndYear = date.add(1, 'year').format("YYYY");
	} else {
		seasonEndYear = date.format("YYYY");
	}
	seasonEndDateString = seasonEndYear + "0601"; // First day of June, always after the end of the regular season
	const url = "/nba/team-stats/" + seasonEndDateString + ".json?team_id=" + req.query.teamId;
	const dataRequest = new DataRequest(url, config);
	dataRequest.send((err, response) => {
		if (err) {
			res.status(err).send();
			return;
		}
		res.send(response);
	});
});

app.use(function(req, res, next) {
	res.status(404).send({error: 'Not found'});
});

app.listen(config.port);
