import React from 'react';
import ReactDOM from 'react-dom';

import DateSelect from './DateSelect.jsx';
import GameList from './GameList.jsx';

export default class Date extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
		if (this.props.match.params.date) {
			this.dateString = this.props.match.params.date;
		} else {
			this.dateString = this.getCurrentDateString();
		}
	}

	getCurrentDateString() {
		const moment = require('moment');
		const date = moment();
		return date.format("YYYYMMDD");
	}

	render() {
		return (
			<div>
				<DateSelect date={this.dateString} />
				<GameList date={this.dateString} />
			</div>
		);
	}

}
