import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';

export default class StatLeaders extends Chart {

	constructor(props) {
		super(props);
		this.title = props.categoryDisplayName + " Leaders (" + props.teamAbbreviation + ")";
		this.gridWidth = "third";
		this.chartType = "Pie";
	}

	chartData(props) {
		const labels = [];
		const series = [];
		props.stats.sort((a, b) => {
			if (a[props.category] > b[props.category]) {
				return -1;
			}
			if (a[props.category] < b[props.category]) {
				return 1;
			}
			return 0;
		});
		let total = 0;
		for (let player of props.stats) {
			if (player[props.category] > 0) {
				if (series.length < props.leaderCount) {
					labels.push(player.first_name.substring(0, 1) + '. ' + player.last_name + ' (' + player[props.category] + ')');
					series.push(player[props.category]);
				}
				total += player[props.category];
			}
		}
		return {
			labels: labels,
			series: series
		};
	}

	chartOptions(props) {
		return {
			classNames: {
				sliceDonutSolid: 'pie-chart-slice team ' + props.teamAbbreviation
			},
			total: props.teamStatTotal,
			chartPadding: 75,
			width: 320,
			height: 320,
			labelPosition: 'center',
			labelOffset: 120,
			donut: true,
			donutSolid: true
		};
	}

}
