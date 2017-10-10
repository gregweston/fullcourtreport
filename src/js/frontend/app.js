import React from 'react';
import ReactDom from 'react-dom';
import {BrowserRouter} from 'react-router-dom';
import {Layout} from './components/Layout.jsx';

ReactDOM.render(
	<BrowserRouter>
		<Layout />
	</BrowserRouter>,
	document.getElementById("app")
);
