import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';
import SeriesValuePopup from './SeriesValuePopup.jsx';

export default class BasketTotals extends Chart {

	formatTypeAsClassName(type) {
		return type.toLowerCase().replace(/\s/g, "-");
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

	generateChart(props) {
		const Chartist = require('chartist');
		new Chartist.Bar('.basket-totals.' + this.formatTypeAsClassName(props.type), {
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
		}, {
			axisX: {
				showGrid: false,
				onlyInteger: true
			},
			stackBars: true,
			horizontalBars: true
		}).on('draw', (data) => {
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
		});
	}

	render() {
		return (
			<div className="grid-width-third">
				<h4>{this.props.type} Totals</h4>
				<div className={"basket-totals " + this.formatTypeAsClassName(this.props.type)}></div>
				<SeriesValuePopup text={this.state.popupText} position={this.state.popupPosition} />
			</div>
		)
	}

}
