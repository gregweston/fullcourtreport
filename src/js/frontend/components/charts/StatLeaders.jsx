import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';

export default class StatLeaders extends Chart {

	formatData(stats) {
		const labels = [];
		const series = [];
		stats.sort((a, b) => {
			if (a[this.props.category] > b[this.props.category]) {
				return -1;
			}
			if (a[this.props.category] < b[this.props.category]) {
				return 1;
			}
			return 0;
		});
		let total = 0;
		for (let player of stats) {
			if (player[this.props.category] > 0) {
				if (series.length < this.props.leaderCount) {
					labels.push(player.first_name.substring(0, 1) + '. ' + player.last_name + ' (' + player[this.props.category] + ')');
					series.push(player[this.props.category]);
				}
				total += player[this.props.category];
			}
		}
		return {
			labels: labels,
			series: series,
			total: total
		};
	}

	generateChart(props) {
		const Chartist = require('chartist');
		const data = this.formatData(props.stats);
		new Chartist.Pie('.stat-leaders.' + props.category + '.' + props.teamAbbreviation, {
			labels: data.labels,
			series: data.series
		}, {
			classNames: {
				sliceDonutSolid: 'pie-chart-slice team ' + props.teamAbbreviation
			},
			total: data.total,
			chartPadding: 75,
			width: 320,
			height: 320,
			labelPosition: 'center',
			labelOffset: 120,
			donut: true,
			donutSolid: true
		});
	}

	render() {
		return (
			<div className="grid-width-third">
				<h4>{this.props.categoryDisplayName} Leaders ({this.props.teamAbbreviation})</h4>
				<div className={"stat-leaders " + this.props.category + " " + this.props.teamAbbreviation}></div>
			</div>
		)
	}

}
