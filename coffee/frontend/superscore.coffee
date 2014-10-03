#total_score = away_total_points + home_total_points
#multiplier = 100/total_score
#vertical_start = 100
#
#path_strings = buildPeriodScoringPathStrings away_total_points, home_total_points, multiplier, vertical_start, bar_height
#    
#away_path = createSVGPath path_strings.away, teamShortNames.away
#away_text = createSVGText away_total_points, "start", 0, (vertical_start + bar_height/2)
#
#home_path = createSVGPath path_strings.home, teamShortNames.home
#home_text = createSVGText home_total_points, "end", 100, (vertical_start + bar_height/2)
#
#scoringSVG.appendChild away_path
#scoringSVG.appendChild home_path
#scoringSVG.appendChild away_text
#scoringSVG.appendChild home_text

createSVGCircle = (cx, cy, r, classname) ->
    circle = document.createElementNS 'http://www.w3.org/2000/svg', 'circle'
    circle.setAttributeNS null, "cx", cx
    circle.setAttributeNS null, "cy", cy
    circle.setAttributeNS null, "r", r
    circle.setAttributeNS null, "class", "team " + classname
    return circle

createSVGPath = (pathString, classname) ->
    path = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
    path.setAttributeNS null, "d", pathString
    path.setAttributeNS null, "class", "team " + classname
    path.setAttributeNS null, "stroke-linecap", "round"
    path.setAttributeNS null, "stroke-linejoin", "round"
    return path

createSVGText = (content, anchor, x, y, classname) ->
    text = document.createElementNS 'http://www.w3.org/2000/svg', 'text'
    text.setAttributeNS null, "class", "team " + classname
    text.setAttributeNS null, "text-anchor", anchor
    text.setAttributeNS null, "x", x
    text.setAttributeNS null, "y", y
    text.innerHTML = content
    return text

buildPeriodScoringPathStrings = (away_score, home_score, multiplier, vertical_start, bar_height) ->
    
    away_score_width = away_score * multiplier
    home_score_width = home_score * multiplier
    total_width = away_score_width + home_score_width
    
    away_path_start = 50 - away_score_width #(100 - total_width)/2
    away_path_end = 50 #away_path_start + away_score_width
    home_path_start = 50 + home_score_width #100 - ((100 - total_width)/2)
    home_path_end = 50 #home_path_start - home_score_width
    
    away_path_string =
            "M" + away_path_start  + " " + vertical_start + " L" + away_path_end + " " + vertical_start +
            "L" + away_path_end + " " + (vertical_start + bar_height) +
            "L" + away_path_start  + " " + (vertical_start + bar_height) + " Z"
    home_path_string =
            "M" + home_path_start  + " " + vertical_start + " L" + home_path_end + " " + vertical_start +
            "L" + home_path_end + " " + (vertical_start + bar_height) +
            "L" + home_path_start  + " " + (vertical_start + bar_height) + " Z"
    return {
        away: away_path_string
        home: home_path_string
    }

buildScoringChart = (scoringSVG, teamShortNames, away_period_scores, home_period_scores, away_total_points, home_total_points, bar_height) ->
    max_period_score = 0
    for index in [0..3]
        if away_period_scores[index] > max_period_score
            max_period_score = away_period_scores[index]
        if home_period_scores[index] > max_period_score
            max_period_score = home_period_scores[index]
            
    multiplier = 50/max_period_score
    for index in [0..3]
        total_period_score = away_period_scores[index] + home_period_scores[index]        
        
        vertical_start = (index * 20) + (index * 3)
            
        path_strings = buildPeriodScoringPathStrings away_period_scores[index], home_period_scores[index], multiplier, vertical_start, bar_height
        
        away_path = createSVGPath path_strings.away, teamShortNames.away
        away_text = createSVGText away_period_scores[index], "end", 48, (vertical_start + 10), teamShortNames.away
        
        home_path = createSVGPath path_strings.home, teamShortNames.home
        home_text = createSVGText home_period_scores[index], "start", 52, (vertical_start + 10), teamShortNames.home
        
        scoringSVG.appendChild away_path
        scoringSVG.appendChild home_path
        scoringSVG.appendChild away_text
        scoringSVG.appendChild home_text
        
buildBasketsPathStrings = (attempts, makes, multiplier, horizontal_start, bar_width) ->
    
    makes_height = makes * multiplier
    misses_height = (attempts * multiplier) - makes_height
    
    makes_path_string =
            "M" + horizontal_start  + " 100  L" + horizontal_start + " " + (100 - makes_height) +
            " L" + (horizontal_start + bar_width) + " " + (100 - makes_height) +
            " L" + (horizontal_start + bar_width)  + " 100 Z"
    misses_path_string =
            "M" + horizontal_start  + " " + (100 - makes_height) + " L" + horizontal_start + " " + (100 - (misses_height + makes_height)) +
            " L" + (horizontal_start + bar_width) + " " + (100 - (misses_height + makes_height)) +
            " L" + (horizontal_start + bar_width)  + " " + (100 - makes_height) + " Z"
    return {
        misses:
            path_string: misses_path_string
            vertical_center: 100 - makes_height - misses_height/2
        makes:
            path_string: makes_path_string
            vertical_center: 100 - makes_height/2
    }
        
buildBasketsChart = (svg, teamShortNames, away, home, bar_width) ->
    max_attempts = Math.max away.attempts, home.attempts
    multiplier = 100/max_attempts
    away_bar_start = (50 - bar_width)/2
    home_bar_start = 100 - away_bar_start - bar_width
    path_strings =
        away: buildBasketsPathStrings away.attempts, away.makes, multiplier, away_bar_start, bar_width
        home: buildBasketsPathStrings home.attempts, home.makes, multiplier, home_bar_start, bar_width
    
    away_attempts_path = createSVGPath path_strings.away.misses.path_string, teamShortNames.away
    away_makes_path = createSVGPath path_strings.away.makes.path_string, teamShortNames.away + ' secondary'
    away_misses_text = createSVGText(
        (away.attempts - away.makes) + ' misses',
        'middle',
        away_bar_start + bar_width/2,
        path_strings.away.misses.vertical_center,
        teamShortNames.away
    )
    away_makes_text = createSVGText(
        away.makes + ' makes',
        'middle',
        away_bar_start + bar_width/2,
        path_strings.away.makes.vertical_center,
        teamShortNames.away + ' secondary'
    )
    
    home_attempts_path = createSVGPath path_strings.home.misses.path_string, teamShortNames.home
    home_makes_path = createSVGPath path_strings.home.makes.path_string, teamShortNames.home + ' secondary'
    home_misses_text = createSVGText(
        (home.attempts - home.makes) + ' misses',
        'middle',
        home_bar_start + bar_width/2,
        path_strings.home.misses.vertical_center,
        teamShortNames.home
    )
    home_makes_text = createSVGText(
        home.makes + ' makes',
        'middle',
        home_bar_start + bar_width/2,
        path_strings.home.makes.vertical_center,
        teamShortNames.home + ' secondary'
    )
    
    svg.appendChild away_attempts_path
    svg.appendChild away_makes_path
    svg.appendChild away_misses_text
    svg.appendChild away_makes_text
    
    svg.appendChild home_attempts_path
    svg.appendChild home_makes_path
    svg.appendChild home_misses_text
    svg.appendChild home_makes_text
    
buildScoreDeviationPoints = (away_stats, home_stats) ->
    
    highest = Math.max(
        away_stats.points, away_stats.ppg, away_stats.opponent_ppg_allowed, home_stats.points, home_stats.ppg, home_stats.opponent_ppg_allowed
    )
    lowest = Math.min(
        away_stats.points, away_stats.ppg, away_stats.opponent_ppg_allowed, home_stats.points, home_stats.ppg, home_stats.opponent_ppg_allowed
    )
    difference = highest - lowest
    multiplier = 90/difference
    
    return {
        away:
            points: [(away_stats.points * multiplier) - (lowest * multiplier) + 5,  20, 5]
            ppg: [(away_stats.ppg * multiplier) - (lowest * multiplier) + 5,  20, 5]
            opponent_ppg_allowed: [(away_stats.opponent_ppg_allowed * multiplier) - (lowest * multiplier) + 5,  20, 5]
        home:
            points: [(home_stats.points * multiplier) - (lowest * multiplier) + 5,  60, 5]
            ppg: [(home_stats.ppg * multiplier) - (lowest * multiplier) + 5,  60, 5]
            opponent_ppg_allowed: [(home_stats.opponent_ppg_allowed * multiplier) - (lowest * multiplier) + 5,  60, 5]
    }


$(document).ready ->
    $.getJSON '/data' + location.pathname, (response) ->
        teamShortNames =
            away: response.box_score.away_team.last_name.toLowerCase()
            home: response.box_score.home_team.last_name.toLowerCase()
        # TODO: Add exception for 76ers -> sixers
        
        $('#away-team-name').addClass(teamShortNames.away).html(response.box_score.away_team.full_name)
        
        $('#home-team-name').addClass(teamShortNames.home).html(response.box_score.home_team.full_name)
        
        # Scoring
        
        buildScoringChart(
            $('#scoring-by-quarter svg').get(0),
            teamShortNames,
            response.box_score.away_period_scores,
            response.box_score.home_period_scores,
            response.box_score.away_totals.points,
            response.box_score.home_totals.points,
            20
        )
        
        # Field goals
        
        buildBasketsChart(
            $('#field-goals svg').get(0),
            teamShortNames,
            {
                attempts: response.box_score.away_totals.field_goals_attempted
                makes: response.box_score.away_totals.field_goals_made
            },
            {
                attempts: response.box_score.home_totals.field_goals_attempted
                makes: response.box_score.home_totals.field_goals_made
            },
            40
        )
        
        # Free throws
        
        buildBasketsChart(
            $('#free-throws svg').get(0),
            teamShortNames,
            {
                attempts: response.box_score.away_totals.free_throws_attempted
                makes: response.box_score.away_totals.free_throws_made
            },
            {
                attempts: response.box_score.home_totals.free_throws_attempted
                makes: response.box_score.home_totals.free_throws_made
            },
            40
        )
        
        # Score deviation
        
        away_score_data =
            points: response.box_score.away_totals.points
            ppg: parseFloat response.away_team_stats.team_stats[0].stats.points_per_game_string
            opponent_ppg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.points_per_game_string
        home_score_data =
            points: response.box_score.home_totals.points
            ppg: parseFloat response.home_team_stats.team_stats[0].stats.points_per_game_string
            opponent_ppg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.points_per_game_string
        
        score_deviation_points = buildScoreDeviationPoints away_score_data, home_score_data
        
        svg = $('#score-deviation svg').get(0)
        
        for team, stats of score_deviation_points
            for stat, values of stats
                values.push teamShortNames[team]
                circle = createSVGCircle.apply null, values
                svg.appendChild circle
        
        
        
        
        