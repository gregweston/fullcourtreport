import React from 'react';
import ReactDOM from 'react-dom';

import DateSelect from './DateSelect.jsx';
import GameList from './GameList.jsx';

export default class Date extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
	}

	render() {
		return (
			<div>
				<DateSelect date={this.props.match.params.date} />
				<GameList date={this.props.match.params.date} />
			</div>
		);
	}

}
