import React from 'react';
import ReactDOM from 'react-dom';

export default class FieldGoalTotals extends React.Component {

	componentDidMount() {
		const Chartist = require('chartist');
		new Chartist.Bar('.field-goal-totals', {
			labels: [this.props.awayTeamAbbreviation, this.props.homeTeamAbbreviation],
			series: [
				{
					className: 'made-field-goals',
					data: [this.props.awayFieldGoalsMade, this.props.homeFieldGoalsMade]
				},
				{
					className: 'missed-field-goals',
					data: [
						this.props.awayFieldGoalsAttempted - this.props.awayFieldGoalsMade,
						this.props.homeFieldGoalsAttempted - this.props.homeFieldGoalsMade
					]
				}
			]
		}, {
			axisX: {
				showGrid: false
			},
			stackBars: true
		}).on('draw', (data) => {
			if (data.type === "bar" && data.element.parent().classes().includes("made-field-goals")) {
				if (data.index === 0) {
					data.element.addClass("team " + this.props.awayTeamAbbreviation);
				} else {
					data.element.addClass("team " + this.props.homeTeamAbbreviation);
				}
			}
		});
	}

	render() {
		return (
			<div className="grid-width-third">
				<h3>Field Goal Totals</h3>
				<div className="field-goal-totals"></div>
			</div>
		)
	}

}
