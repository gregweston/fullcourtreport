NBADataGetter = require './modules/NBADataGetter'
moment = require 'moment'
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
    games_for_day = NBADataGetter.getGamesForDay req.params['year'], req.params['month'], req.params['day'], (games) ->
        for event in games.event
            if (
                event.event_id.indexOf(req.params['away_team']) isnt -1 and event.event_id.indexOf(req.params['home_team']) isnt -1 and
                event.event_status is 'completed' and
                (event.season_type is 'regular' or event.season_type is 'post')
            )
                req.session.token = crypto.randomBytes(32).toString('hex')
                res.render 'game', {
                    locals:
                        game_date: moment(event.start_date_time).format('dddd, MMMM D, YYYY [at] h:mm A (ZZ)')
                        token: req.session.token
                }
                break
            else if event.event_id.indexOf(req.params['away_team']) isnt -1 and event.event_id.indexOf(req.params['home_team']) isnt -1
                res.render 'future-game', {
                    locals:
                        team_nicknames:
                            away: event.away_team.team_id
                            home: event.home_team.team_id
                        team_full_names:
                            away: event.away_team.full_name
                            home: event.home_team.full_name
                        game_date: moment(event.start_date_time).format('dddd, MMMM D, YYYY [at] h:mm A (ZZ)')
                }
                break
        # 404

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
    games_for_day = NBADataGetter.getGamesForDay req.params['year'], req.params['month'], req.params['day'], (games) ->
        res.render 'day', {
            locals:
                year: req.params['year']
                month: req.params['month']
                day: req.params['day']
                games: games
                moment: moment
        }
        
exports.today = (req, res, next) ->
    yesterday = moment().subtract(1, 'days').toArray()
    req.params =
        year: yesterday[0]
        month: yesterday[1] + 1
        day: yesterday[2]
    next()
    
