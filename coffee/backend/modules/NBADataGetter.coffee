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

APIHandler = require './APIHandler'
str = require 'string'

team_ids =
    "hawks":         "atlanta-"
    "celtics":       "boston-"
    "nets":          "brooklyn-"
    "bobcats":       "charlotte-"
    "hornets":       "charlotte-"
    "bulls":         "chicago-",
    "cavaliers":     "cleveland-"
    "mavericks":     "dallas-"
    "nuggets":       "denver-"
    "pistons":       "detroit-"
    "warriors":      "golden-state-"
    "rockets":       "houston-"
    "pacers":        "indiana-"
    "clippers":      "los-angeles-"
    "lakers":        "los-angeles-"
    "grizzlies":     "memphis-"
    "heat":          "miami-"
    "bucks":         "milwaukee-"
    "timberwolves":  "minnesota-"
    "pelicans":      "new-orleans-"
    "knicks":        "new-york-"
    "thunder":       "oklahoma-city-"
    "magic":         "orlando-"
    "76ers":         "philadelphia-"
    "suns":          "phoenix-"
    "blazers":       "portland-trail-"
    "kings":         "sacramento-"
    "spurs":         "san-antonio-"
    "raptors":       "toronto-"
    "jazz":          "utah-"
    "wizards":       "washington-"

exports.getBoxScoreData = (params, next) ->
    handler = new APIHandler()
    awayTeamId = team_ids[params['away_team']] + params['away_team']
    homeTeamId = team_ids[params['home_team']] + params['home_team']
    month = str(params['month']).padLeft(2, '0')
    day = str(params['day']).padLeft(2, '0')
    url =
        '/nba/boxscore/' +
        params['year'] +
        month +
        day + '-' +
        awayTeamId + '-at-' + homeTeamId + '.json'
        
    handler.retrieveData url, next
    
exports.getTeamStats = (year, month, day, team, next) ->
    handler = new APIHandler()
    team_id = team_ids[team] + team
    month = str(month).padLeft(2, '0')
    day = str(day).padLeft(2, '0')
    url =
        '/nba/team-stats/' +
        year +
        month +
        day +
        '.json?team_id=' + team_id
    handler.retrieveData url, next
    
exports.getGamesForDay = (year, month, day, next) ->
    handler = new APIHandler()
    month = str(month).padLeft(2, '0')
    day = str(day).padLeft(2, '0')
    url = '/events.json?date=' +
        year +
        month +
        day +
        '&sport=nba'
    handler.retrieveData url, next
    