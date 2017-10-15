import React from 'react';
import ReactDOM from 'react-dom';

import GameList from './GameList.jsx';

export default class Date extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
		this.date = {
			year: this.props.match.params.year,
			month: this.props.match.params.month,
			day: this.props.match.params.day
		};
	}

	render() {
		return <GameList date={this.date} />
	}

}
