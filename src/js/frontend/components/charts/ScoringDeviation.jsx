import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';

export default class ScoringDeviation extends Chart {

	constructor(props) {
		super(props);
		this.title = "Scoring Deviation (" + props.teamAbbreviation + ")";
		this.gridWidth = "third";
		this.chartType = "Bar";
	}

	getSeriesPopupContent(hoverEvent) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		return value;
	}

	chartData(props) {
		return {
			labels: [
				'This Game',
				'Avg Per Game',
				props.otherTeamAbbreviation + ' Avg Allowed'
			],
			series: [
				[
					props.pointsInThisGame,
					props.averagePointsPerGame,
					props.opponentAveragePointsAllowed
				]
			]
		};
	}

	chartOptions(props) {
		return {
			classNames: {
				bar: 'ct-bar team ' + props.teamAbbreviation
			},
			low: 50
		};
	}

	chartCallbacks(props) {
		return [
			{
				event: 'draw',
				function: (data) => {
					if (data.type === "bar") {
						let bar = data.element.getNode();
						this.addHoverEventHandlersToSeries(bar);
					}
				}
			}
		];
	}

}
