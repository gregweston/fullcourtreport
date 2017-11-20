import React from 'react';
import ReactDOM from 'react-dom';

import {Link} from 'react-router-dom';

const moment = require('moment');

export default class DateSelect extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			datesToDisplay: null,
			previousDate: null,
			nextDate: null
		};
	}

	setDatesToDisplay(dateString) {
		const numberOfDatesBeforeToday = Math.floor(this.props.numberOfDatesToDisplay/2);
		const countingDate = moment(dateString, "YYYYMMDD").subtract(numberOfDatesBeforeToday, 'days');
		const previousDate = moment(dateString, "YYYYMMDD").subtract(1, 'days');
		const nextDate = moment(dateString, "YYYYMMDD").add(1, 'days');
		const datesToDisplay = [];

		for (let counter = 0; counter < this.props.numberOfDatesToDisplay; counter++) {
			datesToDisplay.push({
				value: countingDate.format("YYYYMMDD"),
				display: countingDate.format("M/D")
			});
			countingDate.add(1, 'days');
		}

		this.setState({
			datesToDisplay: datesToDisplay,
			previousDate: previousDate.format("YYYYMMDD"),
			nextDate: nextDate.format("YYYYMMDD")
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
			<li key={date.value} className={date.value == this.props.date ? "date-current" : ""}>
				<Link to={"/date/" + date.value}>{date.display}</Link>
			</li>
		);
		return (
			<ul className="date-select">
				<li className="date-previous">
					<Link to={"/date/" + this.state.previousDate}>Prev</Link>
				</li>
				{dateListItems}
				<li className="date-next">
					<Link to={"/date/" + this.state.nextDate}>Next</Link>
				</li>
			</ul>
		);
	}

}
