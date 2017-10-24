import React from 'react';
import ReactDOM from 'react-dom';

export default class GameHeading extends React.Component {

	winnerClassIfApplicable(homeOrAway) {
		if (homeOrAway === "home" && this.props.homeTeamTotalPoints > this.props.awayTeamTotalPoints) {
			return "winner";
		}
		if (homeOrAway === "away" && this.props.awayTeamTotalPoints > this.props.homeTeamTotalPoints) {
			return "winner";
		}
		return "";
	}

	render() {
		return (
			<h2 className="grid-width-full">
				<span className={"team " + this.props.awayTeamAbbreviation}>
					<span className={"total-points " + this.winnerClassIfApplicable("away")}>
						{this.props.awayTeamTotalPoints}
					</span>
					{this.props.awayTeamFullName}
				</span>
				<span>@</span>
				<span className={"team " + this.props.homeTeamAbbreviation}>
					{this.props.homeTeamFullName}
					<span className={"total-points " + this.winnerClassIfApplicable("home")}>
						{this.props.homeTeamTotalPoints}
					</span>
				</span>
			</h2>
		);
	}

}
