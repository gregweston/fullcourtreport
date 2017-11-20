import React from 'react';
import ReactDOM from 'react-dom';

import ApiComponent from './ApiComponent.jsx';
import Spinner from './Spinner.jsx';
import GameHeading from './GameHeading.jsx';
import GameDetails from './GameDetails.jsx';
import TeamScoringByPeriod from './charts/TeamScoringByPeriod.jsx';
import BasketTotals from './charts/BasketTotals.jsx';
import StatLeaders from './charts/StatLeaders.jsx';
import ScoringDeviation from './charts/ScoringDeviation.jsx';
import StatTotals from './charts/StatTotals.jsx';

export default class Game extends ApiComponent {

	constructor(props) {
		super(props);
		this.gameId = [
			this.props.match.params.date,
			this.props.match.params.awayTeamId,
			"at",
			this.props.match.params.homeTeamId
		].join("-");
		this.secondaryColorCombos = require("../data/secondary-color-combos.json");
		this.secondaryColorClass = "";
		this.state = {
			boxScore: null,
			awayTeamStats: null,
			homeTeamStats: null,
			errorMessage: null
		};
	}

	componentWillMount() {
		this.getGameData(this.props);
	}

	componentWillReceiveProps(nextProps) {
		this.getGameData(nextProps);
	}

	setPageTitle(awayTeamName, homeTeamName, dateString) {
		const moment = require("moment");
		const date = moment(dateString, "YYYYMMDD");
		const formattedDate = date.format("MMM D, YYYY");
		document.title = `Fullcourt Report - ${awayTeamName} at ${homeTeamName} - ${formattedDate}`;
	}

	getGameData(props) {

		this.setState({
			boxScore: null,
			awayTeamStats: null,
			homeTeamStats: null,
			errorMessage: null
		});

		this.callApi("/api/box-score?gameId=" + this.gameId, (responseJson) => {
				let boxScore = responseJson;
				this.secondaryColorClass = "";
				for (let combo of this.secondaryColorCombos) {
					if (combo.includes(boxScore.away_team.abbreviation) && combo.includes(boxScore.home_team.abbreviation)) {
						this.secondaryColorClass = " secondary-team-color-" + combo[0];
						break;
					}
				}
				this.setState({
					boxScore: boxScore
				});

				this.setPageTitle(
					boxScore.away_team.full_name,
					boxScore.home_team.full_name,
					this.props.match.params.date
				);
			}, [
				{status: 404, text: "This game either hasn't happened yet, or doesn't exist."}
			]
		);

		this.callApi("/api/team-stats?date=" + props.match.params.date + "&teamId=" + props.match.params.awayTeamId, (responseJson) => {
			this.setState({
				awayTeamStats: responseJson.team_stats[0]
			});
		});

		this.callApi("/api/team-stats?date=" + props.match.params.date + "&teamId=" + props.match.params.homeTeamId, (responseJson) => {
			this.setState({
				homeTeamStats: responseJson.team_stats[0]
			});
		});
	}

	render() {
		if (this.state.errorMessage) {
			return <div className="error">{this.state.errorMessage}</div>
		}
		if (this.state.boxScore === null || this.state.awayTeamStats === null || this.state.homeTeamStats === null) {
			return <Spinner />;
		}
		const awayTeamAbbr = this.state.boxScore.away_team.abbreviation;
		const homeTeamAbbr = this.state.boxScore.home_team.abbreviation;
		return (
			<div className={"game-info" + this.secondaryColorClass}>

				<GameHeading
					awayTeamFullName={this.state.boxScore.away_team.full_name}
					homeTeamFullName={this.state.boxScore.home_team.full_name}
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayTeamTotalPoints={this.state.boxScore.away_totals.points}
					homeTeamTotalPoints={this.state.boxScore.home_totals.points} />

				<GameDetails
					timestamp={this.state.boxScore.event_information.start_date_time}
					city={this.state.boxScore.event_information.site.city}
					state={this.state.boxScore.event_information.site.state} />

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

				<StatLeaders
					teamAbbreviation={awayTeamAbbr}
					category="points"
					categoryDisplayName="Scoring"
					leaderCount="5"
					teamStatTotal={this.state.boxScore.away_totals.points}
					stats={this.state.boxScore.away_stats} />

				<StatLeaders
					teamAbbreviation={homeTeamAbbr}
					category="points"
					categoryDisplayName="Scoring"
					leaderCount="5"
					teamStatTotal={this.state.boxScore.home_totals.points}
					stats={this.state.boxScore.home_stats} />

				<BasketTotals
					type="Free Throw"
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayBasketsMade={this.state.boxScore.away_totals.free_throws_made}
					awayBasketsAttempted={this.state.boxScore.away_totals.free_throws_attempted}
					homeBasketsMade={this.state.boxScore.home_totals.free_throws_made}
					homeBasketsAttempted={this.state.boxScore.home_totals.free_throws_attempted} />

				<ScoringDeviation
					teamAbbreviation={awayTeamAbbr}
					otherTeamAbbreviation={homeTeamAbbr}
					pointsInThisGame={this.state.boxScore.away_totals.points}
					averagePointsPerGame={this.state.awayTeamStats.stats.points_per_game_string}
					opponentAveragePointsAllowed={this.state.homeTeamStats.stats_opponent.points_per_game_string} />

				<ScoringDeviation
					teamAbbreviation={homeTeamAbbr}
					otherTeamAbbreviation={awayTeamAbbr}
					pointsInThisGame={this.state.boxScore.home_totals.points}
					averagePointsPerGame={this.state.homeTeamStats.stats.points_per_game_string}
					opponentAveragePointsAllowed={this.state.awayTeamStats.stats_opponent.points_per_game_string} />

				<BasketTotals
					type="Three Point Field Goal"
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayBasketsMade={this.state.boxScore.away_totals.three_point_field_goals_made}
					awayBasketsAttempted={this.state.boxScore.away_totals.three_point_field_goals_attempted}
					homeBasketsMade={this.state.boxScore.home_totals.three_point_field_goals_made}
					homeBasketsAttempted={this.state.boxScore.home_totals.three_point_field_goals_attempted} />

				<StatTotals
					category="rebounds"
					categoryDisplayName="Rebounding"
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayStatTotal={this.state.boxScore.away_totals.rebounds}
					homeStatTotal={this.state.boxScore.home_totals.rebounds} />

				<StatLeaders
					teamAbbreviation={awayTeamAbbr}
					category="rebounds"
					categoryDisplayName="Rebounding"
					leaderCount="5"
					teamStatTotal={this.state.boxScore.away_totals.rebounds}
					stats={this.state.boxScore.away_stats} />

				<StatLeaders
					teamAbbreviation={homeTeamAbbr}
					category="rebounds"
					categoryDisplayName="Rebounding"
					leaderCount="5"
					teamStatTotal={this.state.boxScore.home_totals.rebounds}
					stats={this.state.boxScore.home_stats} />

				<StatTotals
					category="assists"
					categoryDisplayName="Assist"
					awayTeamAbbreviation={awayTeamAbbr}
					homeTeamAbbreviation={homeTeamAbbr}
					awayStatTotal={this.state.boxScore.away_totals.assists}
					homeStatTotal={this.state.boxScore.home_totals.assists} />

				<StatLeaders
					teamAbbreviation={awayTeamAbbr}
					category="assists"
					categoryDisplayName="Assist"
					leaderCount="3"
					teamStatTotal={this.state.boxScore.away_totals.assists}
					stats={this.state.boxScore.away_stats} />

				<StatLeaders
					teamAbbreviation={homeTeamAbbr}
					category="assists"
					categoryDisplayName="Assist"
					leaderCount="3"
					teamStatTotal={this.state.boxScore.home_totals.assists}
					stats={this.state.boxScore.home_stats} />

			</div>
		);
	}

}
