/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Memcached = require('memcached');
const https = require('https');
const zlib = require('zlib');
const config = require('../config');

class APIHandler {

    constructor() {
        this.apiKey = config.apiKey;
        this.userAgent = config.userAgent;
        this.timeZone = 'America/New_York';
        this.host = config.host;
        this.memcachedServer = config.memcachedServer;
    }

    retrieveData(url, next) {
        const cache = new Memcached(this.memcachedServer);
        return cache.get(url, (err, data) => {
            if (err != null) { return next(err); }
            if (data != null) {
                console.log(`retrieving from cache: ${url}`);
                return next(JSON.parse(data));
            }
            return this.callAPI(url, cache, next);
        });
    }

    handleResponseBody(cache, url, body, next) {
        cache.set(url, body, config.apiResponseCacheTime, function(err) {
            if (err != null) { return next(err); }
        });
        return next(JSON.parse(body));
    }

    callAPI(url, cache, next) {
        console.log(`retrieving from api: ${url}`);
        const options = {
            host: this.host,
            path: url,
            headers: {
                'Accept-Encoding': 'gzip',
                'Authorization': `Bearer ${this.apiKey}`,
                'User-Agent': this.userAgent
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

module.exports = APIHandler;
