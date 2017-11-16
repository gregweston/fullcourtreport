import React from 'react';
import ReactDOM from 'react-dom';

export default class ApiComponent extends React.Component {

	callApi(url, callback, errorMessages) {
		fetch(url).then((response) => {
			if (!response.ok) {
				if (response.status === 429) {
					this.setState({
						errorMessage: "Unable to retrieve game data right now. Please try again later."
					});
				} else if (errorMessages && errorMessages.length > 0) {
					for (let errorMessage of errorMessages) {
						if (response.status === errorMessage.status) {
							this.setState({
								errorMessage: errorMessage.text
							});
						}
					}
				}
				return;
			}
			response.json().then(callback);
		});
	}

}
