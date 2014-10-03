NBADataGetter = require './modules/NBADataGetter'

gameDataReady = (box_score, away_team_stats, home_team_stats) ->
    if box_score isnt null and away_team_stats isnt null and home_team_stats isnt null
        return {
            box_score: box_score
            away_team_stats: away_team_stats
            home_team_stats: home_team_stats
        }
    return false

exports.game = (req, res) ->
    res.render 'game'

exports.gameData = (req, res) ->
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
        
exports.index = (req, res) ->
    res.write 'Hello index.'
    res.end()
    
