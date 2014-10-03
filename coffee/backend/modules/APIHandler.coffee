
Memcached = require 'memcached'
https = require 'https'
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
                console.log 'from cache'
                return next JSON.parse(data)
            @callAPI url, cache, next
    
    callAPI: (url, cache, next) ->
        console.log 'from api'
        options =
            host: @host
            path: url
            headers:
                'Authorization': 'Bearer ' + @apiKey
                'User-Agent': @userAgent
        https.get options, (res) ->
            body = ''
            res.on 'data', (chunk) ->
                body += chunk
            res.on 'end', ->
                cache.set url, body, 3600 * 24, (err) ->
                    return next(err) if err?
                next JSON.parse(body)
                
module.exports = APIHandler