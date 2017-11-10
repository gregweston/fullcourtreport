import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';
import SeriesValuePopup from './SeriesValuePopup.jsx';

export default class TeamScoringByPeriod extends Chart {

	constructor(props) {
		super(props);
		this.games = null;
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

	getSeriesPopupContent(hoverEvent) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		const team = element.dataset.team;
		return team + ": " + value;
	}

	generateChart(props) {
		const Chartist = require('chartist');
		new Chartist.Bar('.team-scoring-by-period', {
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
		}, {
			axisX: {
				showGrid: false
			},
			seriesBarDistance: 20
		}).on('draw', (data) => {
			if (data.type === "bar") {
				let bar = data.element.getNode();
				if (data.seriesIndex === 0) {
					bar.dataset.team = props.awayTeamAbbreviation;
				} else {
					bar.dataset.team = props.homeTeamAbbreviation;
				}
				this.addHoverEventHandlersToSeries(bar);
			}
		});
	}

	render() {
		return (
			<div className="grid-width-two-thirds">
				<h4>Team Scoring By Period</h4>
				<div className="team-scoring-by-period"></div>
				<SeriesValuePopup text={this.state.popupText} position={this.state.popupPosition} />
			</div>
		);
	}

}
