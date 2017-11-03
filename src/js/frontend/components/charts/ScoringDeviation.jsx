import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';
import ElementValuePopup from './ElementValuePopup.jsx';

export default class ScoringDeviation extends Chart {

	getSeriesPopupContent(hoverEvent) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		return value;
	}

	componentDidMount() {
		const Chartist = require('chartist');
		new Chartist.Bar('.scoring-deviation.' + this.props.teamAbbreviation, {
			labels: [
				'This Game',
				'Avg Per Game',
				this.props.otherTeamAbbreviation + ' Avg Allowed'
			],
			series: [
				[
					this.props.pointsInThisGame,
					this.props.averagePointsPerGame,
					this.props.opponentAveragePointsAllowed
				]
			]
		}, {
			classNames: {
				bar: 'ct-bar team ' + this.props.teamAbbreviation
			}
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
				<h3>Scoring Deviation ({this.props.teamAbbreviation})</h3>
				<div className={"scoring-deviation " + this.props.teamAbbreviation}></div>
				<ElementValuePopup text={this.state.popupText} position={this.state.popupPosition} />
			</div>
		)
	}

}
