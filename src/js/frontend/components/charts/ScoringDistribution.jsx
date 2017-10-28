import React from 'react';
import ReactDOM from 'react-dom';

export default class ScoringDistribution extends React.Component {

	formatScoringData(stats) {
		const labels = [];
		const series = [];
		stats.sort((a, b) => {
			if (a.points > b.points) {
				return -1;
			}
			if (a.points < b.points) {
				return 1;
			}
			return 0;
		})
		for (let player of stats) {
			if (player.points > 0) {
				labels.push(player.first_name.substring(0, 1) + '. ' + player.last_name + ' (' + player.points + ')');
				series.push(player.points);
			}
		}
		return {
			labels: labels,
			series: series
		};
	}

	componentDidMount() {
		const Chartist = require('chartist');
		const scoringData = this.formatScoringData(this.props.stats);
		new Chartist.Pie('.scoring-share.' + this.props.teamAbbreviation, {
			labels: scoringData.labels,
			series: scoringData.series
		}, {
			classNames: {
				slicePie: 'pie-chart-slice team ' + this.props.teamAbbreviation,
				label: 'ct-label pie-chart-label'
			},
			chartPadding: 75,
			width: 320,
			height: 320,
			labelPosition: 'center',
			labelOffset: 120
		});
	}

	render() {
		return (
			<div className="grid-width-third">
				<h3>Scoring Distribution ({this.props.teamAbbreviation})</h3>
				<div className={"scoring-share " + this.props.teamAbbreviation}></div>
			</div>
		)
	}

}
