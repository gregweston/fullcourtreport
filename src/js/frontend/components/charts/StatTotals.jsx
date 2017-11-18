import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';

export default class StatTotals extends Chart {

	constructor(props) {
		super(props);
		this.title = props.categoryDisplayName + " Totals";
		this.gridWidth = "third";
		this.chartType = "Bar";
	}

	getSeriesPopupContent(event) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		const team = element.dataset.team;
		return team + ": " + value + " " + this.props.category;
	}

	chartData(props) {
		return {
			labels: [props.homeTeamAbbreviation, props.awayTeamAbbreviation],
			series: [
				[props.homeStatTotal, props.awayStatTotal]
			]
		};
	}

	chartOptions(props) {
		return {
			axisX: {
				showGrid: false,
				onlyInteger: true
			},
			horizontalBars: true
		};
	}

	chartCallbacks(props) {
		return [
			{
				event: 'draw',
				function: (data) => {
					if (data.type === "bar") {
						let bar = data.element.getNode();
						if (data.index === 1) {
							data.element.addClass("team " + props.awayTeamAbbreviation);
							bar.dataset.team = props.awayTeamAbbreviation;
						} else {
							data.element.addClass("team " + props.homeTeamAbbreviation);
							bar.dataset.team = props.homeTeamAbbreviation;
						}
						this.addHoverEventHandlersToSeries(bar);
					}
				}
			}
		];
	}

}
