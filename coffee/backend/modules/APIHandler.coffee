#   Copyright (C) 2014 Greg Weston
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.

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