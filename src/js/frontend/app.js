import React from 'react';
import ReactDOM from 'react-dom';
import {BrowserRouter, Route, Link, Switch} from 'react-router-dom';

import Date from './components/Date.jsx'
import Game from './components/Game.jsx'
import NotFound from './components/NotFound.jsx'

ReactDOM.render(
	<BrowserRouter>
		<Switch>
			<Route path="/date/:date" component={Date} />
			<Route path="/game/:date/:awayTeamId/:homeTeamId" component={Game} />
			<Route path="/" exact component={Date} />
			<Route component={NotFound} />
		</Switch>
	</BrowserRouter>,
	document.getElementById("app")
);
