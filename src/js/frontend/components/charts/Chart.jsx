import React from 'react';
import ReactDOM from 'react-dom';

export default class Chart extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			popupText: null,
			popupPosition: {
				x: 0,
				y: 0
			}
		};
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
			popupText: null,
			popupPosition: {
				x: 0,
				y: 0
			}
		});
	}

}
