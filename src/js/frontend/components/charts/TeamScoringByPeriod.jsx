import React from 'react';
import ReactDOM from 'react-dom';

import ElementValuePopup from './ElementValuePopup.jsx';

export default class TeamScoringByPeriod extends React.Component {

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

	showSeriesValue(event) {
		const element = event.target;
		const value = element.getAttribute("ct:value");
		const team = element.dataset.team;
		this.setState({
			popupText: team + ": " + value,
			popupPosition: {
				x: window.scrollX + event.clientX,
				y: window.scrollY + event.clientY
			}
		});
	}

	moveSeriesValue(event) {
		this.setState({
			popupPosition: {
				x: window.scrollX + event.clientX,
				y: window.scrollY + event.clientY
			}
		});
	}

	hideSeriesValue(event) {
		this.setState({
			popupText: null,
			popupPosition: {
				x: 0,
				y: 0
			}
		});
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
				bar.addEventListener("mouseover", this.showSeriesValue.bind(this));
				bar.addEventListener("mousemove", this.moveSeriesValue.bind(this));
				bar.addEventListener("mouseout", this.hideSeriesValue.bind(this));
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
		)
	}

}
