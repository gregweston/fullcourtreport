import React from 'react';
import ReactDOM from 'react-dom';

import DateSelect from './DateSelect.jsx';
import GameList from './GameList.jsx';

export default class Date extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
		this.state = {
			dateString: null
		};

	}

	setDateString(props) {
		let dateString;
		if (props.match.params.date) {
			dateString = props.match.params.date;
		} else {
			dateString = this.getCurrentDateString();
		}
		this.setPageTitle(dateString);
		this.setState({
			dateString: dateString
		});
	}

	componentWillMount() {
		this.setDateString(this.props);
	}

	componentWillReceiveProps(nextProps) {
		this.setDateString(nextProps);
	}

	setPageTitle(dateString) {
		const moment = require("moment");
		const date = moment(dateString, "YYYYMMDD");
		const formattedDate = date.format("MMM D, YYYY");
		document.title = `Fullcourt Report - All Games for ${formattedDate}`;
	}

	getCurrentDateString() {
		const moment = require('moment');
		const date = moment();
		return date.format("YYYYMMDD");
	}

	render() {
		return (
			<div>
				<DateSelect date={this.state.dateString} />
				<GameList date={this.state.dateString} />
			</div>
		);
	}

}
