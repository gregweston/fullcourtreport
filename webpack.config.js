const webpack = require('webpack');

module.exports = {
	entry: __dirname + "/src/frontend/app.js",
	output: {
		path: __dirname + "/public/assets/js",
		filename: "bundle.js"
	},
	plugins: [
		new webpack.DefinePlugin({
			"process.env": {
				NODE_ENV: JSON.stringify("production")
			}
		}),
		new webpack.optimize.UglifyJsPlugin({minimize: true})
	],
	module: {
		loaders: [
			{
				test: /\.jsx?$/,
				loader: "babel-loader",
				exclude: /node_modules/,
				query: {
					presets: ["es2015", "react"]
				}
			}
		]
	}
};
