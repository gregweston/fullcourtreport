import React from 'react';
import ReactDOM from 'react-dom';

import {Link} from 'react-router-dom';

export default class GameLink extends React.Component {

	render() {
		return (
			<Link className="game-link" to={"/game/" + this.props.date + "/" + this.props.awayTeamId + "/" + this.props.homeTeamId}>
				<span className={"team " + this.props.awayTeamAbbreviation}>{this.props.awayTeamFullName}</span>
				<span className={"team " + this.props.homeTeamAbbreviation}>{this.props.homeTeamFullName}</span>
			</Link>
		);
	}

}
