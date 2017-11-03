import React from 'react';
import ReactDOM from 'react-dom';

import {Link} from 'react-router-dom';

export default class DateSelect extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			datesToDisplay: null
		};
	}

	setDatesToDisplay(dateString) {
		const moment = require('moment');
		const date = moment(dateString, "YYYYMMDD").subtract(3, 'days');
		const datesToDisplay = [];
		for (let counter = 0; counter < 7; counter++) {
			datesToDisplay.push({
				value: date.format("YYYYMMDD"),
				display: date.format("M/D")
			});
			date.add(1, 'days');
		}
		this.setState({
			datesToDisplay: datesToDisplay
		});
	}

	componentWillMount() {
		this.setDatesToDisplay(this.props.date);
	}

	componentWillReceiveProps(nextProps) {
		this.setDatesToDisplay(nextProps.date);
	}

	render() {
		const dateListItems = this.state.datesToDisplay.map((date) =>
			<li key={date.value}>
				<Link to={"/date/" + date.value}>{date.display}</Link>
			</li>
		);
		return <ul className="date-select">{dateListItems}</ul>
	}

}
