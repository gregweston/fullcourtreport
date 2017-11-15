import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';

export default class TeamScoringByPeriod extends Chart {

	constructor(props) {
		super(props);
		this.title = "Team Scoring By Period";
		this.gridWidth = "two-thirds";
		this.chartType = "Bar";
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

	chartData(props) {
		return {
			labels: this.generateLabels(props.homeTeamScores.length),
			series: [
				{
					className: 'team ' + props.awayTeamAbbreviation,
					data: props.awayTeamScores
				},
				{
					className: 'team ' + props.homeTeamAbbreviation,
					data: props.homeTeamScores
				}
			]
		};
	}

	chartOptions(props) {
		return {
			axisX: {
				showGrid: false
			},
			seriesBarDistance: 20
		};
	}

	chartCallbacks(props) {
		return [
			{
				event: 'draw',
				function: (data) => {
					if (data.type === "bar") {
						let bar = data.element.getNode();
						if (data.seriesIndex === 0) {
							bar.dataset.team = props.awayTeamAbbreviation;
						} else {
							bar.dataset.team = props.homeTeamAbbreviation;
						}
						this.addHoverEventHandlersToSeries(bar);
					}
				}
			}
		];
	}

	getSeriesPopupContent(hoverEvent) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		const team = element.dataset.team;
		return team + ": " + value;
	}

}
