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

NBADataGetter = require './modules/NBADataGetter'
moment = require 'moment-timezone'
crypto = require 'crypto'

gameDataReady = (box_score, away_team_stats, home_team_stats) ->
    if box_score isnt null and away_team_stats isnt null and home_team_stats isnt null
        return {
            box_score: box_score
            away_team_stats: away_team_stats
            home_team_stats: home_team_stats
        }
    return false

exports.game = (req, res) ->
    games_for_day = NBADataGetter.getGamesForDay req.params['year'], req.params['month'], req.params['day'], (day) ->
        if day.event.length > 0
            for event in day.event
                if (
                    event.event_id.indexOf(req.params['away_team']) isnt -1 and event.event_id.indexOf(req.params['home_team']) isnt -1 and
                    event.event_status is 'completed' and
                    (event.season_type is 'regular' or event.season_type is 'post')
                )
                    req.session.token = crypto.randomBytes(32).toString('hex')
                    game_date = moment.tz(event.start_date_time, 'America/New_York').format('dddd, MMMM D, YYYY [at] h:mm A (z)')
                    return res.render 'game', {
                        locals:
                            title: ' | ' + event.away_team.full_name + ' at ' + event.home_team.full_name + ' | ' + game_date
                            game_date: game_date
                            token: req.session.token
                    }
                else if event.event_id.indexOf(req.params['away_team']) isnt -1 and event.event_id.indexOf(req.params['home_team']) isnt -1
                    game_date = moment.tz(event.start_date_time, 'America/New_York').format('dddd, MMMM D, YYYY [at] h:mm A (z)')
                    return res.render 'future-game', {
                        locals:
                            title: ' | ' + event.away_team.full_name + ' at ' + event.home_team.full_name + ' | ' + game_date
                            team_nicknames:
                                away: event.away_team.team_id
                                home: event.home_team.team_id
                            team_full_names:
                                away: event.away_team.full_name
                                home: event.home_team.full_name
                            game_date: game_date
                    }
            res.status(404).render('404')
        else
            res.status(404).render('404')

exports.gameData = (req, res) ->
    return res.json({"error": "Invalid request token"}) if req.query.t isnt req.session.token or !req.session.token?
    req.session.token = crypto.randomBytes(32).toString('hex')
    box_score = null
    away_team_stats = null
    home_team_stats = null
    
    NBADataGetter.getBoxScoreData req.params, (data) ->
        box_score = data
        gameData = gameDataReady box_score, away_team_stats, home_team_stats
        res.json(gameData) if gameData
        
    NBADataGetter.getTeamStats req.params['year'], req.params['month'], req.params['day'], req.params['away_team'], (data) ->
        away_team_stats = data
        gameData = gameDataReady box_score, away_team_stats, home_team_stats
        res.json(gameData) if gameData
        
    NBADataGetter.getTeamStats req.params['year'], req.params['month'], req.params['day'], req.params['home_team'], (data) ->
        home_team_stats = data
        gameData = gameDataReady box_score, away_team_stats, home_team_stats
        res.json(gameData) if gameData
        
exports.day = (req, res) ->
    games_for_day = NBADataGetter.getGamesForDay(req.params['year'], req.params['month'], req.params['day'], (games) ->
        res.render 'day', {
            locals:
                title: ' | ' + moment(new Date(games.events_date)).format('dddd, MMMM D, YYYY')
                year: req.params['year']
                month: req.params['month']
                day: req.params['day']
                games: games
                moment: moment
        }
    )
