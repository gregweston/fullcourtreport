import React from 'react';
import ReactDOM from 'react-dom';

export default class ScoringPerQuarter extends React.Component {

	constructor(props) {
		super(props);
		this.games = null;
	}

	componentDidMount() {
		const Chartist = require('chartist');
		new Chartist.Bar('#scoring-per-quarter', {
			labels: ['Q1', 'Q2', 'Q3', 'Q4'],
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
		return <div id="scoring-per-quarter" className=""></div>
	}

}
