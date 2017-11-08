import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';
import ElementValuePopup from './ElementValuePopup.jsx';

export default class StatTotals extends Chart {

	getSeriesPopupContent(hoverEvent) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		const team = element.dataset.team;
		return team + ": " + value + " " + this.props.category;
	}

	generateChart(props) {
		const Chartist = require('chartist');
		new Chartist.Bar('.stat-totals.' + this.props.category, {
			labels: [props.awayTeamAbbreviation, props.homeTeamAbbreviation],
			series: [
				[props.awayStatTotal, props.homeStatTotal]
			]
		}, {
			axisX: {
				showGrid: false,
				onlyInteger: true
			},
			horizontalBars: true
		}).on('draw', (data) => {
			if (data.type === "bar") {
				let bar = data.element.getNode();
				if (data.index === 0) {
					data.element.addClass("team " + props.awayTeamAbbreviation);
					bar.dataset.team = props.awayTeamAbbreviation;
				} else {
					data.element.addClass("team " + props.homeTeamAbbreviation);
					bar.dataset.team = props.homeTeamAbbreviation;
				}
				this.addHoverEventHandlersToSeries(bar);
			}
		});
	}

	render() {
		return (
			<div className="grid-width-third">
				<h4>{this.props.categoryDisplayName} Totals</h4>
				<div className={"stat-totals " + this.props.category}></div>
				<ElementValuePopup text={this.state.popupText} position={this.state.popupPosition} />
			</div>
		)
	}

}
