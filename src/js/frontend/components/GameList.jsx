import React from 'react';
import ReactDOM from 'react-dom';

import GameLink from './GameLink.jsx';

export default class GameList extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			games: null
		};
	}

	componentWillMount() {
		const params = new URLSearchParams();
		params.append("year", this.props.date.year);
		params.append("month", this.props.date.month);
		params.append("day", this.props.date.day);
		fetch("/api/games-on-date?" + params.toString()).then((response) => {
			response.json().then((responseJson) => {
				this.setState({
					"games": responseJson.event
				});
			});
		});
	}

	render() {
		if (this.state.games === null) {
			return null;
		}
		const gameLinks = this.state.games.map((game) => {
			return (
				<li key={game.event_id}>
					<GameLink
						eventId={game.event_id}
						awayTeamAbbreviation={game.away_team.abbreviation}
						awayTeamFullName={game.away_team.full_name}
						homeTeamAbbreviation={game.home_team.abbreviation}
						homeTeamFullName={game.home_team.full_name} />
				</li>
			)
		});
		return <ul className="game-list">{gameLinks}</ul>
	}

}
