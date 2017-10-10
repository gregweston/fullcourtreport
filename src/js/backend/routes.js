/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const NBADataGetter = require('./modules/NBADataGetter');
const moment = require('moment-timezone');
const crypto = require('crypto');

const gameDataReady = function(box_score, away_team_stats, home_team_stats) {
    if ((box_score !== null) && (away_team_stats !== null) && (home_team_stats !== null)) {
        return {
            box_score,
            away_team_stats,
            home_team_stats
        };
    }
    return false;
};

exports.game = function(req, res) {
    let games_for_day;
    return games_for_day = NBADataGetter.getGamesForDay(req.params['year'], req.params['month'], req.params['day'], function(day) {
        if (day.event.length > 0) {
            for (let event of Array.from(day.event)) {
                var game_date;
                if (
                    (event.event_id.indexOf(req.params['away_team']) !== -1) && (event.event_id.indexOf(req.params['home_team']) !== -1) &&
                    (event.event_status === 'completed') &&
                    ((event.season_type === 'regular') || (event.season_type === 'post'))
                ) {
                    req.session.token = crypto.randomBytes(32).toString('hex');
                    game_date = moment.tz(event.start_date_time, 'America/New_York').format('dddd, MMMM D, YYYY [at] h:mm A (z)');
                    return res.render('game', {
                        locals: {
                            title: ` | ${event.away_team.full_name} at ${event.home_team.full_name} | ${game_date}`,
                            game_date,
                            token: req.session.token
                        }
                    });
                } else if ((event.event_id.indexOf(req.params['away_team']) !== -1) && (event.event_id.indexOf(req.params['home_team']) !== -1)) {
                    game_date = moment.tz(event.start_date_time, 'America/New_York').format('dddd, MMMM D, YYYY [at] h:mm A (z)');
                    return res.render('future-game', {
                        locals: {
                            title: ` | ${event.away_team.full_name} at ${event.home_team.full_name} | ${game_date}`,
                            team_nicknames: {
                                away: event.away_team.team_id,
                                home: event.home_team.team_id
                            },
                            team_full_names: {
                                away: event.away_team.full_name,
                                home: event.home_team.full_name
                            },
                            game_date
                        }
                    });
                }
            }
            return res.status(404).render('404');
        } else {
            return res.status(404).render('404');
        }
    });
};

exports.gameData = function(req, res) {
    if ((req.query.t !== req.session.token) || (req.session.token == null)) { return res.json({"error": "Invalid request token"}); }
    req.session.token = crypto.randomBytes(32).toString('hex');
    let box_score = null;
    let away_team_stats = null;
    let home_team_stats = null;

    NBADataGetter.getBoxScoreData(req.params, function(data) {
        box_score = data;
        const gameData = gameDataReady(box_score, away_team_stats, home_team_stats);
        if (gameData) { return res.json(gameData); }
    });

    NBADataGetter.getTeamStats(req.params['year'], req.params['month'], req.params['day'], req.params['away_team'], function(data) {
        away_team_stats = data;
        const gameData = gameDataReady(box_score, away_team_stats, home_team_stats);
        if (gameData) { return res.json(gameData); }
    });

    return NBADataGetter.getTeamStats(req.params['year'], req.params['month'], req.params['day'], req.params['home_team'], function(data) {
        home_team_stats = data;
        const gameData = gameDataReady(box_score, away_team_stats, home_team_stats);
        if (gameData) { return res.json(gameData); }
    });
};

exports.day = function(req, res) {
    let games_for_day;
    return games_for_day = NBADataGetter.getGamesForDay(req.params['year'], req.params['month'], req.params['day'], games =>
        res.render('day', {
            locals: {
                title: ` | ${moment(new Date(games.events_date)).format('dddd, MMMM D, YYYY')}`,
                year: req.params['year'],
                month: req.params['month'],
                day: req.params['day'],
                games,
                moment
            }
        })
    );
};
