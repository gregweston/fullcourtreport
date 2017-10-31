import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';
import ElementValuePopup from './ElementValuePopup.jsx';

export default class TeamScoringByPeriod extends Chart {

	constructor(props) {
		super(props);
		this.games = null;
		this.state = {
			popupText: null,
			popupPosition: {
				x: 0,
				y: 0
			}
		};
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

	componentDidMount() {
		const Chartist = require('chartist');
		new Chartist.Bar('.team-scoring-by-period', {
			labels: this.generateLabels(this.props.homeTeamScores.length),
			series: [
				{
					className: 'team ' + this.props.awayTeamAbbreviation,
					data: this.props.awayTeamScores
				},
				{
					className: 'team ' + this.props.homeTeamAbbreviation,
					data: this.props.homeTeamScores
				}
			]
		}, {
			axisX: {
				showGrid: false
			},
			classNames: {
				bar: 'ct-bar team-scoring-chart-bar'
			},
			seriesBarDistance: 30
		}).on('draw', (data) => {
			if (data.type === "bar") {
				let bar = data.element.getNode();
				if (data.seriesIndex === 0) {
					bar.dataset.team = this.props.awayTeamAbbreviation;
				} else {
					bar.dataset.team = this.props.homeTeamAbbreviation;
				}
				this.addHoverEventHandlersToSeries(bar);
			}
		});
	}

	render() {
		return (
			<div className="grid-width-two-thirds">
				<h3>Team Scoring By Period</h3>
				<div className="team-scoring-by-period"></div>
				<ElementValuePopup text={this.state.popupText} position={this.state.popupPosition} />
			</div>
		);
	}

}
