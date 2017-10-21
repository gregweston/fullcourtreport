import React from 'react';
import ReactDOM from 'react-dom';

export default class TeamScoringByPeriod extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
	}

	generateLabels(periodCount) {
		const labels = ['Q1', 'Q2', 'Q3', 'Q4'];
		const overtimePeriodCount = periodCount - 4;
		if (overtimePeriodCount > 0) {
			for (let i = 1; i <= overtimePeriodCount; i++) {
				labels.push('OT' + i.toString());
			}
		}
		return labels;
	}

	componentDidMount() {
		const Chartist = require('chartist');
		new Chartist.Bar('#scoring-per-quarter', {
			labels: this.generateLabels(this.props.homeTeamScores.length),
			series: [
				{
					className: 'team ' + this.props.awayTeamAbbreviation,
					data: this.props.awayTeamScores
				},
				{
					className: 'team ' + this.props.homeTeamAbbreviation,
					data: this.props.homeTeamScores
				}
			]
		});
	}

	render() {
		return (
			<div id="scoring-per-quarter-container">
				<h3>Team Scoring By Period</h3>
				<div id="scoring-per-quarter"></div>
			</div>
		)
	}

}
