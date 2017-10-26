import React from 'react';
import ReactDOM from 'react-dom';

export default class BasketTotals extends React.Component {

	formatTypeAsClassName(type) {
		return type.toLowerCase().replace(" ", "-");
	}

	componentDidMount() {
		const Chartist = require('chartist');
		new Chartist.Bar('.basket-totals.' + this.formatTypeAsClassName(this.props.type), {
			labels: [this.props.awayTeamAbbreviation, this.props.homeTeamAbbreviation],
			series: [
				{
					className: 'made-baskets',
					data: [this.props.awayBasketsMade, this.props.homeBasketsMade]
				},
				{
					className: 'missed-baskets',
					data: [
						this.props.awayBasketsAttempted - this.props.awayBasketsMade,
						this.props.homeBasketsAttempted - this.props.homeBasketsMade
					]
				}
			]
		}, {
			axisX: {
				showGrid: false
			},
			stackBars: true
		}).on('draw', (data) => {
			if (data.type === "bar" && data.element.parent().classes().includes("made-baskets")) {
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
				<h3>{this.props.type} Totals</h3>
				<div className={"basket-totals " + this.formatTypeAsClassName(this.props.type)}></div>
			</div>
		)
	}

}
