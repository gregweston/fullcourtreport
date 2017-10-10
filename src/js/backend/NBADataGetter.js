const APIHandler = require('./APIHandler');
const str = require('string');

const team_ids = {
    "hawks":         "atlanta-",
    "celtics":       "boston-",
    "nets":          "brooklyn-",
    "hornets":       "charlotte-",
    "bulls":         "chicago-",
    "cavaliers":     "cleveland-",
    "mavericks":     "dallas-",
    "nuggets":       "denver-",
    "pistons":       "detroit-",
    "warriors":      "golden-state-",
    "rockets":       "houston-",
    "pacers":        "indiana-",
    "clippers":      "los-angeles-",
    "lakers":        "los-angeles-",
    "grizzlies":     "memphis-",
    "heat":          "miami-",
    "bucks":         "milwaukee-",
    "timberwolves":  "minnesota-",
    "pelicans":      "new-orleans-",
    "knicks":        "new-york-",
    "thunder":       "oklahoma-city-",
    "magic":         "orlando-",
    "76ers":         "philadelphia-",
    "suns":          "phoenix-",
    "trail-blazers": "portland-",
    "kings":         "sacramento-",
    "spurs":         "san-antonio-",
    "raptors":       "toronto-",
    "jazz":          "utah-",
    "wizards":       "washington-"
};

exports.getBoxScoreData = function(params, next) {
    const handler = new APIHandler();
    const awayTeamId = team_ids[params['away_team']] + params['away_team'];
    const homeTeamId = team_ids[params['home_team']] + params['home_team'];
    const month = str(params['month']).padLeft(2, '0');
    const day = str(params['day']).padLeft(2, '0');
    const url =
        '/nba/boxscore/' +
        params['year'] +
        month +
        day + '-' +
        awayTeamId + '-at-' + homeTeamId + '.json';
    return handler.retrieveData(url, next);
};

exports.getTeamStats = function(year, month, day, team, next) {
    const handler = new APIHandler();
    const team_id = team_ids[team] + team;
    month = str(month).padLeft(2, '0');
    day = str(day).padLeft(2, '0');
    const url =
        '/nba/team-stats/' +
        year +
        month +
        day +
        '.json?team_id=' + team_id;
    return handler.retrieveData(url, next);
};

exports.getGamesForDay = function(year, month, day, next) {
    const handler = new APIHandler();
    month = str(month).padLeft(2, '0');
    day = str(day).padLeft(2, '0');
    const url = '/events.json?date=' +
        year +
        month +
        day +
        '&sport=nba';
    return handler.retrieveData(url, next);
};
