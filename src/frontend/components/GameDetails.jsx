import React from 'react';
import ReactDOM from 'react-dom';

export default class GameDetails extends React.Component {

	constructor(props) {
		super(props);
		this.formatDateAndTime = this.formatDateAndTime.bind(this);
	}

	formatDateAndTime(timestamp) {
		const moment = require('moment');
		const date = moment(timestamp, moment.ISO_8601);
		return date.format("dddd, MMMM D, YYYY [at] h:mm A (Z)");
	}

	render() {
		return (
			<div className="grid-width-full">
				<h3>
					{this.formatDateAndTime(this.props.timestamp)}
					<br />
					{this.props.city}, {this.props.state}
				</h3>
			</div>
		);
	}

}
