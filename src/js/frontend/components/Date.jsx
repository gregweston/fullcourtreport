import React from 'react';
import ReactDOM from 'react-dom';

export class Date extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
		this.date = {
			year: this.props.match.params.year,
			month: this.props.match.params.month,
			day: this.props.match.params.day
		};
	}

	componentWillMount() {
		fetch("/api/date/" + this.date.year + "/" + this.date.month + "/" + this.date.day)
			.then((response) => {
				response.json().then((responseJson) => {
					console.log(responseJson);
				});
			});
	}

	render() {
		return (
			<p>Today is {this.date.month} {this.date.day}, {this.date.year}.</p>
		);
	}

}
