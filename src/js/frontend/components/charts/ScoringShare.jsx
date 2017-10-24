import React from 'react';
import ReactDOM from 'react-dom';

export default class ScoringShare extends React.Component {

	formatScoringData(stats) {
		const labels = [];
		const series = [];
		stats.sort((a, b) => {
			if (a.points < b.points) {
				return -1;
			}
			if (a.points > b.points) {
				return 1;
			}
			return 0;
		})
		for (let player of stats) {
			if (player.points > 0) {
				labels.push(player.display_name);
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
		new Chartist.Pie('.scoring-share', {
			labels: scoringData.labels,
			series: scoringData.series
		}, {
			classNames: {
				slicePie: 'team pie-chart-slice ' + this.props.teamAbbreviation
			},
			width: 400,
			height: 400
		});
	}

	render() {
		return (
			<div className="grid-width-half">
				<h3>Scoring Share ({this.props.teamAbbreviation})</h3>
				<div className="scoring-share"></div>
			</div>
		)
	}

}
