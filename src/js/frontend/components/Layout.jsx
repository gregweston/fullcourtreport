import React from 'react';
import ReactDOM from 'react-dom';
import {Route, Link, Switch} from 'react-router-dom';

import {Date} from './Date.jsx'
import {Game} from './Game.jsx'

class Layout {
	render() {
		return(
			<Switch>
				<Route path="/date/:year/:month/:day" component={Date} />
				<Route path="/game/:year/:month/:day/:roadTeam/:homeTeam" component={Game} />
			</Switch>
		);
	}
}
