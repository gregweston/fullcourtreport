import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';
import SeriesValuePopup from './SeriesValuePopup.jsx';

export default class ScoringDeviation extends Chart {

	getSeriesPopupContent(hoverEvent) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		return value;
	}

	generateChart(props) {
		const Chartist = require('chartist');
		new Chartist.Bar('.scoring-deviation.' + props.teamAbbreviation, {
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
		}, {
			classNames: {
				bar: 'ct-bar team ' + props.teamAbbreviation
			},
			low: 50
		}).on('draw', (data) => {
			if (data.type === "bar") {
				let bar = data.element.getNode();
				this.addHoverEventHandlersToSeries(bar);
			}
		});
	}

	render() {
		return (
			<div className="grid-width-third">
				<h4>Scoring Deviation ({this.props.teamAbbreviation})</h4>
				<div className={"scoring-deviation " + this.props.teamAbbreviation}></div>
				<SeriesValuePopup text={this.state.popupText} position={this.state.popupPosition} />
			</div>
		)
	}

}
