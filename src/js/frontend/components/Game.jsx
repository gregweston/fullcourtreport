import React from 'react';
import ReactDOM from 'react-dom';

import ScoringPerQuarter from './charts/ScoringPerQuarter.jsx';

export default class Game extends React.Component {

	constructor(props) {
		super(props);
		this.gameId = [
			this.props.match.params.date,
			this.props.match.params.awayTeamId,
			"at",
			this.props.match.params.homeTeamId
		].join("-");
		this.state = {
			boxScore: null,
			awayTeamStats: null,
			homeTeamStats: null
		};
	}

	componentWillMount() {
		fetch("/api/box-score?gameId=" + this.gameId).then((response) => {
			response.json().then((responseJson) => {
				this.setState({
					boxScore: responseJson
				});
			});
		});
		fetch("/api/team-stats?date=" + this.props.match.params.date + "&teamId=" + this.props.match.params.awayTeamId).then((response) => {
			response.json().then((responseJson) => {
				this.setState({
					awayTeamStats: responseJson
				});
			});
		});
		fetch("/api/team-stats?date=" + this.props.match.params.date + "&teamId=" + this.props.match.params.homeTeamId).then((response) => {
			response.json().then((responseJson) => {
				this.setState({
					homeTeamStats: responseJson
				});
			});
		});
	}

	render() {
		if (this.state.boxScore === null) {
			return "";
		}
		const awayTeamAbbr = this.state.boxScore.away_team.abbreviation;
		const homeTeamAbbr = this.state.boxScore.home_team.abbreviation;
		return (
			<div class="game-info">
				<h2>
					<span className={"team " + awayTeamAbbr}>{this.state.boxScore.away_team.full_name}</span>
					@
					<span className={"team " + homeTeamAbbr}>{this.state.boxScore.home_team.full_name}</span>
				</h2>
				<ScoringPerQuarter
					awayTeamAbbreviation={this.state.boxScore.away_team.abbreviation}
					homeTeamAbbreviation={this.state.boxScore.home_team.abbreviation}
					awayTeamScores={this.state.boxScore.away_period_scores || null}
					homeTeamScores={this.state.boxScore.home_period_scores || null} />
			</div>
		);
	}

}
