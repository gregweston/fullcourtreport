import React from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart.jsx';
import ElementValuePopup from './ElementValuePopup.jsx';

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
				showGrid: false,
				onlyInteger: true
			},
			stackBars: true,
			horizontalBars: true
		}).on('draw', (data) => {
			if (data.type === "bar") {
				let isMadeBasketsBar = data.element.parent().classes().includes("made-baskets");
				let bar = data.element.getNode();
				if (data.index === 0) {
					if (isMadeBasketsBar) {
						data.element.addClass("team " + this.props.awayTeamAbbreviation);
					}
					bar.dataset.team = this.props.awayTeamAbbreviation;
				} else {
					if (isMadeBasketsBar) {
						data.element.addClass("team " + this.props.homeTeamAbbreviation);
					}
					bar.dataset.team = this.props.homeTeamAbbreviation;
				}
				this.addHoverEventHandlersToSeries(bar);
			}
		});
	}

	render() {
		return (
			<div className="grid-width-third">
				<h3>{this.props.type} Totals</h3>
				<div className={"basket-totals " + this.formatTypeAsClassName(this.props.type)}></div>
				<ElementValuePopup text={this.state.popupText} position={this.state.popupPosition} />
			</div>
		)
	}

}
