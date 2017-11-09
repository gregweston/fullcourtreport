import React from 'react';
import ReactDOM from 'react-dom';

import Spinner from './Spinner.jsx';
import GameLink from './GameLink.jsx';

export default class GameList extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			games: null
		};
	}

	componentWillMount() {
		this.getGamesForDate(this.props.date);
	}

	componentWillReceiveProps(nextProps) {
		this.getGamesForDate(nextProps.date);
	}

	getGamesForDate(date) {
		this.setState({
			"games": null
		});
		fetch("/api/games?date=" + date).then((response) => {
			response.json().then((responseJson) => {
				this.setState({
					"games": responseJson.event
				});
			});
		});
	}

	render() {
		if (this.state.games === null) {
			return <Spinner />;
		}
		const gameLinks = this.state.games.map((game) => {
			return (
				<li key={game.event_id}>
					<GameLink
						date={this.props.date}
						awayTeamId={game.away_team.team_id}
						awayTeamAbbreviation={game.away_team.abbreviation}
						awayTeamFullName={game.away_team.full_name}
						homeTeamId={game.home_team.team_id}
						homeTeamAbbreviation={game.home_team.abbreviation}
						homeTeamFullName={game.home_team.full_name} />
				</li>
			)
		});
		return <ul className="game-list">{gameLinks}</ul>
	}

}
