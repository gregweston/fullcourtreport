import React from 'react';
import ReactDOM from 'react-dom';

import GameList from './GameList.jsx';

export default class Date extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
	}

	render() {
		return <GameList date={this.props.match.params.date} />
	}

}
