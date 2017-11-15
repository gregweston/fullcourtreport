import React from 'react';
import ReactDOM from 'react-dom';

import SeriesValuePopup from './SeriesValuePopup.jsx';

const Chartist = require('chartist');

export default class Chart extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			popupText: "",
			popupPosition: {
				x: 0,
				y: 0
			}
		};
	}

	generateChart(data, options, callbacks) {
		const chart = new Chartist[this.chartType](this.chartElement, data, options);
		if (callbacks.length > 0) {
			for (let callback of callbacks) {
				chart.on(callback.event, callback.function);
			}
		}
	}

	chartCallbacks(props) {
		return [];
	}

	componentDidMount() {
		const data = this.chartData(this.props);
		const options = this.chartOptions(this.props);
		const callbacks = this.chartCallbacks(this.props);
		this.generateChart(data, options, callbacks);
	}

	componentWillReceiveProps(nextProps) {
		const data = this.chartData(nextProps);
		const options = this.chartOptions(nextProps);
		const callbacks = this.chartCallbacks(nextProps);
		this.generateChart(data, options, callbacks);
	}

	addHoverEventHandlersToSeries(element) {
		element.addEventListener("mouseover", this.showSeriesValue.bind(this));
		element.addEventListener("mousemove", this.moveSeriesValue.bind(this));
		element.addEventListener("mouseout", this.hideSeriesValue.bind(this));
	}

	showSeriesValue(event) {
		this.setState({
			popupText: this.getSeriesPopupContent(event),
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
			popupText: "",
			popupPosition: {
				x: 0,
				y: 0
			}
		});
	}

	render() {
		return (
			<div className={"grid-width-" + this.gridWidth}>
				<h4>{this.title}</h4>
				<div ref={element => this.chartElement = element}></div>
				{this.state.popupText.length > 0 &&
					<SeriesValuePopup text={this.state.popupText} position={this.state.popupPosition} />
				}
			</div>
		);
	}

}
