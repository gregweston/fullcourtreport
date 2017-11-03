import React from 'react';
import ReactDOM from 'react-dom';
import {BrowserRouter, Route, Link, Switch} from 'react-router-dom';

import Date from './components/Date.jsx'
import Game from './components/Game.jsx'

ReactDOM.render(
	<BrowserRouter>
		<Switch>
			<Route path="/date/:date" component={Date} />
			<Route path="/game/:date/:awayTeamId/:homeTeamId" component={Game} />
			<Route path="/" component={Date} />
		</Switch>
	</BrowserRouter>,
	document.getElementById("app")
);
