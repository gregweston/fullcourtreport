
Memcached = require 'memcached'
https = require 'https'
zlib = require 'zlib'
config = require '../config'

class APIHandler

    constructor: ->
        @apiKey = config.apiKey
        @userAgent = config.userAgent
        @timeZone = 'America/New_York'
        @host = config.host
        @memcachedServer = config.memcachedServer
        
    retrieveData: (url, next) ->
        cache = new Memcached @memcachedServer
        cache.get url, (err, data) =>
            return next(err) if err?
            if data?
                console.log 'retrieving from cache: ' + url
                return next JSON.parse(data)
            @callAPI url, cache, next
    
    handleResponseBody: (cache, url, body, next) ->
        cache.set url, body, 3600 * 24, (err) ->
            return next(err) if err?
        next JSON.parse(body)
    
    callAPI: (url, cache, next) ->
        console.log 'retrieving from api: ' + url
        options =
            host: @host
            path: url
            headers:
                'Accept-Encoding': 'gzip'
                'Authorization': 'Bearer ' + @apiKey
                'User-Agent': @userAgent
        https.get options, (res) =>
            chunks = []
            res.on 'error', (err) ->
                return next(err)
            res.on 'data', (chunk) ->
                chunks.push chunk
            res.on 'end', =>
                return next('Unexpected response from server') if res.statusCode isnt 200
                buffer = Buffer.concat chunks
                encoding = res.headers['content-encoding']
                if encoding is 'gzip'
                    zlib.gunzip buffer, (err, body) =>
                        return next(err) if err?
                        @handleResponseBody cache, url, body, next
                else
                    @handleResponseBody cache, url, buffer, next
                
module.exports = APIHandler