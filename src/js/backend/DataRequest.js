const Memcached = require('memcached');
const https = require('https');
const zlib = require('zlib');

class DataRequest {

	constructor(url, config) {
		this.url = url;
		this.config = config;
		this.cache = new Memcached(this.config.memcachedServer);
	}

	send(next) {
		return this.cache.get(this.url, (err, data) => {
			if (err != null) {
				return next(err);
			}
			if (data != null) {
				console.log(`retrieving from cache: ${this.url}`);
				return next(null, JSON.parse(data));
			}
			return this.callAPI(next);
		});
	}

	handleResponseBody(body, next) {
		this.cache.set(this.url, body, this.config.apiResponseCacheTime, (err) => {
			if (err != null) {
				return next(err);
			}
		});
		return next(null, JSON.parse(body));
	}

	callAPI(next) {
		console.log(`retrieving from api: ${this.url}`);
		const options = {
			host: this.config.host,
			path: this.url,
			headers: {
				'Accept-Encoding': 'gzip',
				'Authorization': `Bearer ${this.config.apiKey}`,
				'User-Agent': this.config.userAgent
			}
		};
		return https.get(options, res => {
			const chunks = [];
			res.on('error', err => next(err));
			res.on('data', chunk => chunks.push(chunk));
			return res.on('end', () => {
				if (res.statusCode !== 200) {
					return next(res.statusCode);
				}
				const buffer = Buffer.concat(chunks);
				const encoding = res.headers['content-encoding'];
				if (encoding === 'gzip') {
					return zlib.gunzip(buffer, (err, body) => {
						if (err != null) {
							return next(err);
						}
						return this.handleResponseBody(body, next);
					});
				} else {
					return this.handleResponseBody(buffer, next);
				}
			});
		});
	}
}

module.exports = DataRequest;
