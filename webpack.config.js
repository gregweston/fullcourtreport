module.exports = {
	entry: __dirname + "/src/js/frontend/app.js",
	output: {
		path: __dirname + "/public/assets/js",
		filename: "bundle.js"
	},
	resolve: {
		extensions: ['.js', '.jsx']
	},
	module: {
		loaders: [
			{
				test: /\.jsx?$/,
				loader: 'babel-loader',
				exclude: /node_modules/,
				query: {
					presets: ['es2015', 'react']
				}
			}
		]
	}
};
