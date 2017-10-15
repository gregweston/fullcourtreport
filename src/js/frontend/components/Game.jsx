import React from 'react';
import ReactDOM from 'react-dom';

export default class Game extends React.Component {

	constructor(props) {
		super(props);
		this.gameId = [
			this.props.match.params.date,
			this.props.match.params.awayTeamId,
			"at",
			this.props.match.params.homeTeamId
		].join("-");
	}

	componentWillMount() {
		fetch("/api/box-score?gameId=" + this.gameId).then((response) => {
			response.json().then((responseJson) => {
				console.log(responseJson);
			});
		});
		fetch("/api/team-stats?date=" + this.props.match.params.date + "&teamId=" + this.props.match.params.awayTeamId).then((response) => {
			response.json().then((responseJson) => {
				console.log(responseJson);
			});
		});
		fetch("/api/team-stats?date=" + this.props.match.params.date + "&teamId=" + this.props.match.params.homeTeamId).then((response) => {
			response.json().then((responseJson) => {
				console.log(responseJson);
			});
		});
	}

	render() {
		return (
			<p>Game</p>
		);
	}

}
