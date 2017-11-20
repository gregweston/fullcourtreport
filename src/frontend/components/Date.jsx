import React from 'react';
import ReactDOM from 'react-dom';

import DateSelect from './DateSelect.jsx';
import GameList from './GameList.jsx';

const moment = require("moment");

export default class Date extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
		this.state = {
			dateString: null,
			invalidDate: false
		};
	}

	setDateString(props) {
		let dateString;
		if (props.match.params.date) {
			dateString = props.match.params.date;
			let dateCheck = moment(dateString, "YYYYMMDD");
			if (!dateCheck.isValid()) {
				this.setState({invalidDate: true});
			}
		} else {
			dateString = this.getDateStringForPreviousDay();
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
		const date = moment(dateString, "YYYYMMDD");
		const formattedDate = date.format("MMM D, YYYY");
		document.title = `Fullcourt Report - All Games for ${formattedDate}`;
	}

	getDateStringForPreviousDay() {
		const moment = require('moment');
		const date = moment();
		return date.subtract(1, "days").format("YYYYMMDD");
	}

	render() {
		if (this.state.invalidDate === true) {
			return <div className="error">Invalid date.</div>
		}
		return (
			<div>
				<DateSelect date={this.state.dateString} numberOfDatesToDisplay="5" />
				<GameList date={this.state.dateString} />
			</div>
		);
	}

}
