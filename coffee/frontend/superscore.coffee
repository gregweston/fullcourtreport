
round = (float, decimal_spaces) ->
    return Math.round(float * (Math.pow(10, decimal_spaces))) / Math.pow(10, decimal_spaces)

createSVGLine = (x1, y1, x2, y2, width, classname) ->
    line = document.createElementNS 'http://www.w3.org/2000/svg', 'line'
    line.setAttributeNS null, 'x1', x1
    line.setAttributeNS null, 'y1', y1
    line.setAttributeNS null, 'x2', x2
    line.setAttributeNS null, 'y2', y2
    line.setAttributeNS null, 'stroke-width', width
    line.setAttributeNS null, 'class', 'team ' + classname
    return line

createSVGCircle = (cx, cy, r, classname) ->
    circle = document.createElementNS 'http://www.w3.org/2000/svg', 'circle'
    circle.setAttributeNS null, 'cx', cx
    circle.setAttributeNS null, 'cy', cy
    circle.setAttributeNS null, 'r', r
    circle.setAttributeNS null, 'class', 'team ' + classname
    return circle

#Create rectangle centered on provided point
createSVGRect = (x, y, width, height, classname) ->
    rect = document.createElementNS 'http://www.w3.org/2000/svg', 'rect'
    rect.setAttributeNS null, 'x', x - width/2
    rect.setAttributeNS null, 'y', y - height/2
    rect.setAttributeNS null, 'width', width
    rect.setAttributeNS null, 'height', height
    rect.setAttributeNS null, 'class', 'team ' + classname
    return rect

#Create triangle centered on provided point
createSVGTriangle = (x, y, width, height, classname) ->
    rect = document.createElementNS 'http://www.w3.org/2000/svg', 'polygon'
    rect.setAttributeNS null, 'points', (x-width/2) + ',' + (y+height/2) + ' ' + x + ',' + (y-height/2) + ' ' + (x+width/2) + ',' + (y+height/2)
    rect.setAttributeNS null, 'class', 'team ' + classname
    return rect

createSVGPath = (pathString, classname) ->
    path = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
    path.setAttributeNS null, 'd', pathString
    path.setAttributeNS null, 'class', 'team ' + classname
    path.setAttributeNS null, 'stroke-linecap', 'round'
    path.setAttributeNS null, 'stroke-linejoin', 'round'
    return path

createSVGText = (content, anchor, x, y, classname) ->
    text = document.createElementNS 'http://www.w3.org/2000/svg', 'text'
    text.setAttributeNS null, 'class', 'team ' + classname
    text.setAttributeNS null, 'text-anchor', anchor
    text.setAttributeNS null, 'x', x
    text.setAttributeNS null, 'y', y + 2
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

buildScoringChart = (scoringSVG, teamShortNames, away_period_scores, home_period_scores, away_total_points, home_total_points) ->
    max_period_score = 0
    bar_height = 100/away_period_scores.length
    for index in [0..3]
        if away_period_scores[index] > max_period_score
            max_period_score = away_period_scores[index]
        if home_period_scores[index] > max_period_score
            max_period_score = home_period_scores[index]
    multiplier = 50/max_period_score
    for score, index in away_period_scores
        total_period_score = away_period_scores[index] + home_period_scores[index]        
        
        vertical_start = index * bar_height
            
        path_strings = buildPeriodScoringPathStrings away_period_scores[index], home_period_scores[index], multiplier, vertical_start, bar_height
        
        away_path = createSVGPath path_strings.away, teamShortNames.away
        away_text = createSVGText away_period_scores[index], "end", 48, (vertical_start + bar_height/2), teamShortNames.away
        
        home_path = createSVGPath path_strings.home, teamShortNames.home
        home_text = createSVGText home_period_scores[index], "start", 52, (vertical_start + bar_height/2), teamShortNames.home
        
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
        teamShortNames.away + ' primary'
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
        teamShortNames.home + ' primary'
    )
    
    svg.appendChild away_attempts_path
    svg.appendChild away_makes_path
    svg.appendChild away_misses_text
    svg.appendChild away_makes_text
    
    svg.appendChild home_attempts_path
    svg.appendChild home_makes_path
    svg.appendChild home_misses_text
    svg.appendChild home_makes_text
    
buildDeviationPoints = (away_stats, home_stats, radius) ->
    
    highest = Math.max(
        away_stats.this_game, away_stats.avg_per_game, away_stats.opponent_avg_allowed, home_stats.this_game, home_stats.avg_per_game, home_stats.opponent_avg_allowed
    )
    lowest = Math.min(
        away_stats.this_game, away_stats.avg_per_game, away_stats.opponent_avg_allowed, home_stats.this_game, home_stats.avg_per_game, home_stats.opponent_avg_allowed
    )
    difference = highest - lowest
    multiplier = 84/difference
    
    return {
        away:
            this_game:
                path: [(away_stats.this_game * multiplier) - (lowest * multiplier) + 8,  20, radius]
                value: round away_stats.this_game, 1
            avg_per_game:
                path: [(away_stats.avg_per_game * multiplier) - (lowest * multiplier) + 8,  20, radius]
                value: round away_stats.avg_per_game, 1
            opponent_avg_allowed:
                path: [(away_stats.opponent_avg_allowed * multiplier) - (lowest * multiplier) + 8,  20, radius]
                value: round away_stats.opponent_avg_allowed, 1
        home:
            this_game:
                path: [(home_stats.this_game * multiplier) - (lowest * multiplier) + 8,  60, radius]
                value: round home_stats.this_game, 1
            avg_per_game:
                path: [(home_stats.avg_per_game * multiplier) - (lowest * multiplier) + 8,  60, radius]
                value: round home_stats.avg_per_game, 1
            opponent_avg_allowed:
                path: [(home_stats.opponent_avg_allowed * multiplier) - (lowest * multiplier) + 8,  60, radius]
                value: round home_stats.opponent_avg_allowed, 1
    }
    
buildDeviationChart = (svg, teamShortNames, away_stats, home_stats)->
    
    deviation_points = buildDeviationPoints away_stats, home_stats, 8
    away_line = createSVGLine 0, 20, 100, 20, 3, teamShortNames.away + ' secondary'
    home_line = createSVGLine 0, 60, 100, 60, 3, teamShortNames.home + ' secondary'
    svg.appendChild away_line
    svg.appendChild home_line
    for team, stats of deviation_points
        for stat, info of stats
            info.path.push teamShortNames[team]
            if stat?
                shape = createSVGCircle.apply null, info.path
            else if stat is 'avg_per_game'
                shape = createSVGRect info.path[0], info.path[1], info.path[2] * 2, info.path[2] * 2, teamShortNames[team]
            else
                shape = createSVGTriangle info.path[0], info.path[1], info.path[2] * 2, info.path[2] * 2, teamShortNames[team]
            label = createSVGText info.value, 'middle', info.path[0], info.path[1], teamShortNames[team] + ' secondary'
            svg.appendChild shape
            svg.appendChild label


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
            response.box_score.home_totals.points
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
        
        # 3 pointers
        
        buildBasketsChart(
            $('#3-pointers svg').get(0),
            teamShortNames,
            {
                attempts: response.box_score.away_totals.three_point_field_goals_attempted
                makes: response.box_score.away_totals.three_point_field_goals_made
            },
            {
                attempts: response.box_score.home_totals.three_point_field_goals_attempted
                makes: response.box_score.home_totals.three_point_field_goals_made
            },
            40
        )
        
        # Score deviation
        
        away_score_data =
            this_game: response.box_score.away_totals.points
            avg_per_game: parseFloat response.away_team_stats.team_stats[0].stats.points_per_game_string
            opponent_avg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.points_per_game_string
        home_score_data =
            this_game: response.box_score.home_totals.points
            avg_per_game: parseFloat response.home_team_stats.team_stats[0].stats.points_per_game_string
            opponent_avg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.points_per_game_string
        
        buildDeviationChart $('#score-deviation svg').get(0), teamShortNames, away_score_data, home_score_data
        
        # Field goal percent deviation
        
        away_fg_data =
            this_game: response.box_score.away_totals.field_goal_percentage * 100
            avg_per_game: parseFloat response.away_team_stats.team_stats[0].stats.field_goal_percentage * 100
            opponent_avg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.field_goal_percentage * 100
        home_fg_data =
            this_game: response.box_score.home_totals.field_goal_percentage * 100
            avg_per_game: parseFloat response.home_team_stats.team_stats[0].stats.field_goal_percentage * 100
            opponent_avg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.field_goal_percentage * 100
        
        buildDeviationChart $('#field-goal-percent-deviation svg').get(0), teamShortNames, away_fg_data, home_fg_data
        
        # 3pt percent deviation
        
        away_3pt_data =
            this_game: response.box_score.away_totals.three_point_percentage * 100
            avg_per_game: parseFloat response.away_team_stats.team_stats[0].stats.three_point_percentage * 100
            opponent_avg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.three_point_percentage * 100
        home_3pt_data =
            this_game: response.box_score.home_totals.three_point_percentage * 100
            avg_per_game: parseFloat response.home_team_stats.team_stats[0].stats.three_point_percentage * 100
            opponent_avg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.three_point_percentage * 100
        
        buildDeviationChart $('#3pt-percent-deviation svg').get(0), teamShortNames, away_3pt_data, home_3pt_data
        
        
        