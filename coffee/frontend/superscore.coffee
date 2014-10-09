
round = (float, decimal_spaces) ->
    return Math.round(float * (Math.pow(10, decimal_spaces))) / Math.pow(10, decimal_spaces)

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
        
        away_path = SVGBuilder.createSVGPath path_strings.away, teamShortNames.away
        away_text = SVGBuilder.createSVGText away_period_scores[index], "end", 48, (vertical_start + bar_height/2), teamShortNames.away
        
        home_path = SVGBuilder.createSVGPath path_strings.home, teamShortNames.home
        home_text = SVGBuilder.createSVGText home_period_scores[index], "start", 52, (vertical_start + bar_height/2), teamShortNames.home
        
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
    
    away_attempts_path = SVGBuilder.createSVGPath path_strings.away.misses.path_string, teamShortNames.away
    away_makes_path = SVGBuilder.createSVGPath path_strings.away.makes.path_string, teamShortNames.away + ' secondary'
    away_misses_text = SVGBuilder.createSVGText(
        (away.attempts - away.makes) + ' misses',
        'middle',
        away_bar_start + bar_width/2,
        path_strings.away.misses.vertical_center,
        teamShortNames.away
    )
    away_makes_text = SVGBuilder.createSVGText(
        away.makes + ' makes',
        'middle',
        away_bar_start + bar_width/2,
        path_strings.away.makes.vertical_center,
        teamShortNames.away + ' primary'
    )
    
    home_attempts_path = SVGBuilder.createSVGPath path_strings.home.misses.path_string, teamShortNames.home
    home_makes_path = SVGBuilder.createSVGPath path_strings.home.makes.path_string, teamShortNames.home + ' secondary'
    home_misses_text = SVGBuilder.createSVGText(
        (home.attempts - home.makes) + ' misses',
        'middle',
        home_bar_start + bar_width/2,
        path_strings.home.misses.vertical_center,
        teamShortNames.home
    )
    home_makes_text = SVGBuilder.createSVGText(
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

buildDeviationChartAxis = (highest, lowest, multiplier) ->
    rounded_highest = round highest, 0
    rounded_lowest = round lowest, 0
    highest_point = 8 - (rounded_highest - highest)
    lowest_point = 92 - (rounded_lowest - lowest)
    return {
        highest:
            point: highest_point 
            value: rounded_highest
        middle:
            point: (highest_point + lowest_point)/2
            value: (rounded_highest + rounded_lowest)/2
        lowest:
            point: lowest_point 
            value: rounded_lowest
    }

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
        labels: buildDeviationChartAxis highest, lowest, multiplier
        points:
            away:
                opponent_avg_allowed:
                    path: [30, 100 - ((away_stats.opponent_avg_allowed * multiplier) - (lowest * multiplier) + 8), radius]
                    value: round away_stats.opponent_avg_allowed, 1
                avg_per_game:
                    path: [30, 100 - ((away_stats.avg_per_game * multiplier) - (lowest * multiplier) + 8), radius]
                    value: round away_stats.avg_per_game, 1
                this_game:
                    path: [30, 100 - ((away_stats.this_game * multiplier) - (lowest * multiplier) + 8), radius]
                    value: round away_stats.this_game, 1
                
            home:
                opponent_avg_allowed:
                    path: [70, 100 - ((home_stats.opponent_avg_allowed * multiplier) - (lowest * multiplier) + 8), radius]
                    value: round home_stats.opponent_avg_allowed, 1
                avg_per_game:
                    path: [70, 100 - ((home_stats.avg_per_game * multiplier) - (lowest * multiplier) + 8), radius]
                    value: round home_stats.avg_per_game, 1
                this_game:
                    path: [70, 100 - ((home_stats.this_game * multiplier) - (lowest * multiplier) + 8), radius]
                    value: round home_stats.this_game, 1
    }
    
buildDeviationChart = (svg, teamShortNames, away_stats, home_stats) ->
    
    deviation_data = buildDeviationPoints away_stats, home_stats, 8
    away_line = SVGBuilder.createSVGLine 30, 0, 30, 100, 3, teamShortNames.away + ' team secondary'
    home_line = SVGBuilder.createSVGLine 70, 0, 70, 100, 3, teamShortNames.home + ' team secondary'
    svg.appendChild away_line
    svg.appendChild home_line
    min_value = null
    max_value = null
    for team, stats of deviation_data.points
        for stat, info of stats
            info.path.push teamShortNames[team]
            if stat is 'opponent_avg_allowed'
                shape = SVGBuilder.createSVGRect info.path[0], info.path[1], info.path[2] * 2, info.path[2] * 2, teamShortNames[team]
            else if stat is 'avg_per_game'
                shape = SVGBuilder.createSVGCircle.apply null, info.path
            else
                shape = SVGBuilder.createSVGTriangle info.path[0], info.path[1], info.path[2] * 2, info.path[2] * 2, teamShortNames[team]
            svg.appendChild shape
    top_label = SVGBuilder.createSVGText deviation_data.labels.highest.value, 'start', 0, deviation_data.labels.highest.point
    middle_label = SVGBuilder.createSVGText deviation_data.labels.middle.value, 'start', 0, deviation_data.labels.middle.point
    bottom_label = SVGBuilder.createSVGText deviation_data.labels.lowest.value, 'start', 0, deviation_data.labels.lowest.point
    svg.appendChild top_label
    svg.appendChild middle_label
    svg.appendChild bottom_label

buildDeviationLegend = (svg) ->
    icons_and_labels = [
        SVGBuilder.createSVGTriangle 5, 10, 8, 8
        SVGBuilder.createSVGText 'This Game', 'start', 9, 10, 'legend'
        SVGBuilder.createSVGCircle 30, 10, 4
        SVGBuilder.createSVGText 'Avg. Per Game', 'start', 35, 10, 'legend'
        SVGBuilder.createSVGRect 60, 10, 8, 8
        SVGBuilder.createSVGText 'Opp. Avg. Allowed', 'start', 66, 10, 'legend'
    ]
    svg.appendChild element for element in icons_and_labels
    
getLeaders = (players, stat) ->
    leaders = []
    for player in players
        if player[stat] > 0
            leaders.push {
                name: player.first_name[0] + '. ' + player.last_name
                value: player[stat]
            }
    leaders.sort (a, b) ->
        if a.value > b.value then return -1
        if a.value < b.value then return 1 else return 0
    return leaders
            
buildPieChart = (svg, teamShortName, width, players, total_points, stat) ->
    radian_converter = (2*Math.PI)/total_points 
    leaders = getLeaders players, stat
    next_starting_point =
        x: 100 - (100 - width)/2
        y: 50
    last_angle = 0
    for leader, index in leaders
        angle = last_angle + (radian_converter * leader.value)
        ending_point =
            x: 50 + ((width/2) * Math.cos(angle))
            y: 50 + ((width/2) * Math.sin(angle))
        
        path_string = 'M' + next_starting_point.x + ' ' + next_starting_point.y + ' A ' + (width/2) + ' ' + (width/2) + ', 0, 0, 1, ' + ending_point.x + ' ' + ending_point.y + ' L50 50 Z'
        #classname = if index%2 is 0 then teamShortName + ' secondary' else teamShortName
        arc = SVGBuilder.createSVGPath path_string, teamShortName + ' secondary'
        svg.appendChild arc
        
        # Halfway point on arc between starting point and ending point
        label_spot =
            x: 50 + ((width/2.2) * Math.cos(angle - (angle-last_angle)/2))
            y: 50 + ((width/2.2) * Math.sin(angle - (angle-last_angle)/2))
            
        # Getting slope of line that will extend from inside of "slice" to label
        line_slope =
            x: (label_spot.x - 50)/5
            y: (label_spot.y - 50)/5
        line = SVGBuilder.createSVGLine label_spot.x, label_spot.y, label_spot.x + line_slope.x, label_spot.y + line_slope.y, .25
        label_anchor = if label_spot.x + line_slope.x < 50 then 'end' else 'start'
        label = SVGBuilder.createSVGText leader.name + ', ' + leader.value, label_anchor, label_spot.x + line_slope.x, label_spot.y + line_slope.y, 'legend'
        svg.appendChild line
        svg.appendChild label
        next_starting_point = ending_point
        last_angle = angle

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
            $('#scoring-by-period svg').get(0),
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
        
        buildDeviationChart $('#score-deviation svg.chart').get(0), teamShortNames, away_score_data, home_score_data
        buildDeviationLegend $('#score-deviation svg.legend').get(0)
        
        # Field goal percent deviation
        
        away_fg_data =
            this_game: response.box_score.away_totals.field_goal_percentage * 100
            avg_per_game: parseFloat response.away_team_stats.team_stats[0].stats.field_goal_percentage * 100
            opponent_avg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.field_goal_percentage * 100
        home_fg_data =
            this_game: response.box_score.home_totals.field_goal_percentage * 100
            avg_per_game: parseFloat response.home_team_stats.team_stats[0].stats.field_goal_percentage * 100
            opponent_avg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.field_goal_percentage * 100
        
        buildDeviationChart $('#field-goal-percent-deviation svg.chart').get(0), teamShortNames, away_fg_data, home_fg_data
        buildDeviationLegend $('#field-goal-percent-deviation svg.legend').get(0)
        
        # 3pt percent deviation
        
        away_3pt_data =
            this_game: response.box_score.away_totals.three_point_percentage * 100
            avg_per_game: parseFloat response.away_team_stats.team_stats[0].stats.three_point_percentage * 100
            opponent_avg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.three_point_percentage * 100
        home_3pt_data =
            this_game: response.box_score.home_totals.three_point_percentage * 100
            avg_per_game: parseFloat response.home_team_stats.team_stats[0].stats.three_point_percentage * 100
            opponent_avg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.three_point_percentage * 100
        
        buildDeviationChart $('#3pt-percent-deviation svg.chart').get(0), teamShortNames, away_3pt_data, home_3pt_data
        buildDeviationLegend $('#3pt-percent-deviation svg.legend').get(0)
        
        # Individual scoring
        
        buildPieChart $('#individual-scoring-away svg').get(0), teamShortNames.away, 60, response.box_score.away_stats, response.box_score.away_totals.points, 'points'
        
        buildPieChart $('#individual-scoring-home svg').get(0), teamShortNames.home, 60, response.box_score.home_stats, response.box_score.home_totals.points, 'points'
        
        # Individual rebounding
        
        buildPieChart $('#individual-rebounding-away svg').get(0), teamShortNames.away, 60, response.box_score.away_stats, response.box_score.away_totals.rebounds, 'rebounds'
        
        buildPieChart $('#individual-rebounding-home svg').get(0), teamShortNames.home, 60, response.box_score.home_stats, response.box_score.home_totals.rebounds, 'rebounds'
        
        # Individual assists
        
        buildPieChart $('#individual-assists-away svg').get(0), teamShortNames.away, 60, response.box_score.away_stats, response.box_score.away_totals.assists, 'assists'
        
        buildPieChart $('#individual-assists-home svg').get(0), teamShortNames.home, 60, response.box_score.home_stats, response.box_score.home_totals.assists, 'assists'
        