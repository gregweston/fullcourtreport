import React from 'react';
import ReactDOM from 'react-dom';

import {Link} from 'react-router-dom';

export default class DateSelect extends React.Component {

	getDatesToDisplay(dateString) {
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
		return datesToDisplay;
	}

	render() {
		const datesToDisplay = this.getDatesToDisplay(this.props.date);
		const dateListItems = datesToDisplay.map((date) =>
			<li key={date.value}>
				<Link to={"/date/" + date.value}>{date.display}</Link>
			</li>
		);
		return <ul>{dateListItems}</ul>
	}

}
