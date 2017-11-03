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
		if (props.match.params.date) {
			this.setState({
				dateString: props.match.params.date
			});
		} else {
			this.setState({
				dateString: this.getCurrentDateString()
			});
		}
	}

	componentWillMount() {
		this.setDateString(this.props);
	}

	componentWillReceiveProps(nextProps) {
		this.setDateString(nextProps);
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
