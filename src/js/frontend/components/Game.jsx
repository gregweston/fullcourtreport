import React from 'react';
import ReactDOM from 'react-dom';

import TeamScoringByPeriod from './charts/TeamScoringByPeriod.jsx';
import GameHeading from './GameHeading.jsx';
import BasketTotals from './charts/BasketTotals.jsx';
import ScoringDistribution from './charts/ScoringDistribution.jsx';

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
			<div className="game-info">

				<GameHeading
					awayTeamFullName={this.state.boxScore.away_team.full_name}
					homeTeamFullName={this.state.boxScore.home_team.full_name}
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayTeamTotalPoints={this.state.boxScore.away_totals.points}
					homeTeamTotalPoints={this.state.boxScore.home_totals.points} />

				<TeamScoringByPeriod
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayTeamScores={this.state.boxScore.away_period_scores}
					homeTeamScores={this.state.boxScore.home_period_scores} />

				<BasketTotals
					type="Field Goal"
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayBasketsMade={this.state.boxScore.away_totals.field_goals_made}
					awayBasketsAttempted={this.state.boxScore.away_totals.field_goals_attempted}
					homeBasketsMade={this.state.boxScore.home_totals.field_goals_made}
					homeBasketsAttempted={this.state.boxScore.home_totals.field_goals_attempted} />

				<ScoringDistribution
					teamAbbreviation={awayTeamAbbr}
					stats={this.state.boxScore.away_stats} />

				<ScoringDistribution
					teamAbbreviation={homeTeamAbbr}
					stats={this.state.boxScore.home_stats} />

				<BasketTotals
					type="Free Throw"
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayBasketsMade={this.state.boxScore.away_totals.free_throws_made}
					awayBasketsAttempted={this.state.boxScore.away_totals.free_throws_attempted}
					homeBasketsMade={this.state.boxScore.home_totals.free_throws_made}
					homeBasketsAttempted={this.state.boxScore.home_totals.free_throws_attempted} />
			</div>
		);
	}

}
