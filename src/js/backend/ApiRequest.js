const Memcached = require('memcached');
const https = require('https');
const zlib = require('zlib');

class ApiRequest {

    constructor(url, config) {
        this.timeZone = 'America/New_York';//config.timezone;
				this.url = url;
				this.config = config;
    }

    send(next) {
			return this.callAPI(url, cache, next);
        /*const cache = new Memcached(this.config.memcachedServer);
        return cache.get(this.url, (err, data) => {
            if (err != null) {
							return next(err);
						}
            if (data != null) {
                console.log(`retrieving from cache: ${url}`);
                return next(null, JSON.parse(data));
            }
            return this.callAPI(url, cache, next);
        });*/
    }

    handleResponseBody(cache, url, body, next) {
        cache.set(url, body, this.config.apiResponseCacheTime, function(err) {
            if (err != null) { return next(err); }
        });
        return next(JSON.parse(body));
    }

    callAPI(url, cache, next) {
        console.log(`retrieving from api: ${url}`);
        const options = {
            host: this.config.host,
            path: url,
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
                if (res.statusCode !== 200) { return next('Unexpected response from server'); }
                const buffer = Buffer.concat(chunks);
                const encoding = res.headers['content-encoding'];
                if (encoding === 'gzip') {
                    return zlib.gunzip(buffer, (err, body) => {
                        if (err != null) { return next(err); }
                        return this.handleResponseBody(cache, url, body, next);
                    });
                } else {
                    return this.handleResponseBody(cache, url, buffer, next);
                }
            });
        });
    }
}

module.exports = ApiRequest;
