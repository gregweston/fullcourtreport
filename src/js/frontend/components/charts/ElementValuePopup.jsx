import React from 'react';
import ReactDOM from 'react-dom';

export default class ElementValuePopup extends React.Component {

	render() {
		let hidden;
		if (this.props.text === null) {
			hidden = "hidden";
		} else {
			hidden = "";
		}
		return (
			<div className={"element-value-popup " + hidden} style={{left: this.props.position.x, top: this.props.position.y}}>
				{this.props.text}
			</div>
		);
	}

}
