import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';
import ElementValuePopup from './ElementValuePopup.jsx';

export default class ReboundTotals extends Chart {

	getSeriesPopupContent(hoverEvent) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		const team = element.dataset.team;
		return team + ": " + value + " rebounds";
	}

	componentDidMount() {
		const Chartist = require('chartist');
		new Chartist.Bar('.rebound-totals', {
			labels: [this.props.awayTeamAbbreviation, this.props.homeTeamAbbreviation],
			series: [
				[this.props.awayRebounds, this.props.homeRebounds]
			]
		}, {
			axisX: {
				showGrid: false,
				onlyInteger: true
			},
			horizontalBars: true
		}).on('draw', (data) => {
			if (data.type === "bar") {
				let isDefensiveReboundsBar = data.element.parent().classes().includes("defensive-rebounds");
				let bar = data.element.getNode();
				if (data.index === 0) {
					data.element.addClass("team " + this.props.awayTeamAbbreviation);
					bar.dataset.team = this.props.awayTeamAbbreviation;
				} else {
					data.element.addClass("team " + this.props.homeTeamAbbreviation);
					bar.dataset.team = this.props.homeTeamAbbreviation;
				}
				this.addHoverEventHandlersToSeries(bar);
			}
		});
	}

	render() {
		return (
			<div className="grid-width-third">
				<h4>Rebound Totals</h4>
				<div className="rebound-totals"></div>
				<ElementValuePopup text={this.state.popupText} position={this.state.popupPosition} />
			</div>
		)
	}

}
