import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';

export default class BasketTotals extends Chart {

	constructor(props) {
		super(props);
		this.title = props.type + " Totals";
		this.gridWidth = "third";
		this.chartType = "Bar";
	}

	getSeriesPopupContent(hoverEvent) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		const team = element.dataset.team;
		if (element.parentElement.classList.contains("made-baskets")) {
			return team + ": " + value + " made";
		} else {
			return team + ": " + value + " missed";
		}
	}

	chartData(props) {
		return {
			labels: [props.homeTeamAbbreviation, props.awayTeamAbbreviation],
			series: [
				{
					className: 'made-baskets',
					data: [props.homeBasketsMade, props.awayBasketsMade]
				},
				{
					className: 'missed-baskets',
					data: [
						props.homeBasketsAttempted - props.homeBasketsMade,
						props.awayBasketsAttempted - props.awayBasketsMade
					]
				}
			]
		};
	}

	chartOptions(props) {
		return {
			axisX: {
				showGrid: false,
				onlyInteger: true
			},
			stackBars: true,
			horizontalBars: true
		};
	}

	chartCallbacks(props) {
		return [
			{
				event: 'draw',
				function: (data) => {
					if (data.type === "bar") {
						let isMadeBasketsBar = data.element.parent().classes().includes("made-baskets");
						let bar = data.element.getNode();
						if (data.index === 1) {
							if (isMadeBasketsBar) {
								data.element.addClass("team " + props.awayTeamAbbreviation);
							}
							bar.dataset.team = props.awayTeamAbbreviation;
						} else {
							if (isMadeBasketsBar) {
								data.element.addClass("team " + props.homeTeamAbbreviation);
							}
							bar.dataset.team = props.homeTeamAbbreviation;
						}
						this.addHoverEventHandlersToSeries(bar);
					}
				}
			}
		];
	}

}
