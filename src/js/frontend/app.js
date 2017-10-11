import React from 'react';
import ReactDom from 'react-dom';
import {BrowserRouter, Route, Link, Switch} from 'react-router-dom';

import {Date} from './Date.jsx'
import {Game} from './Game.jsx'

ReactDOM.render(
	<BrowserRouter>
		<Switch>
			<Route path="/date/:year/:month/:day" component={Date} />
			<Route path="/game/:year/:month/:day/:roadTeam/:homeTeam" component={Game} />
		</Switch>
	</BrowserRouter>,
	document.getElementById("app")
);
