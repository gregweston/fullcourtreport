import React from 'react';
import ReactDOM from 'react-dom';

import ApiComponent from './ApiComponent.jsx';
import Spinner from './Spinner.jsx';
import GameLink from './GameLink.jsx';

export default class GameList extends ApiComponent {

	constructor(props) {
		super(props);
		this.state = {
			games: null,
			errorMessage: null
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
			games: null,
			errorMessage: null
		});

		this.callApi("/api/games?date=" + date, (responseJson) => {
			if (responseJson.event.length === 0) {
				this.setState({errorMessage: "No games found for this day."});
			}
			this.setState({games: responseJson.event});
		});
	}

	render() {
		if (this.state.errorMessage) {
			return <div className="error">{this.state.errorMessage}</div>
		}
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
