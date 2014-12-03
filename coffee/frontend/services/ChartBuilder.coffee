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

fullcourt.service 'ChartBuilder', (SVGBuilder) -> 
    return {
        round: (float, decimal_spaces) ->
            return Math.round(float * (Math.pow(10, decimal_spaces))) / Math.pow(10, decimal_spaces)
        
        buildPeriodScoringPathStrings: (away_score, home_score, multiplier, vertical_start, bar_height) ->
            
            away_score_width = away_score * multiplier
            home_score_width = home_score * multiplier
            total_width = away_score_width + home_score_width
            
            away_path_start = 50 - away_score_width
            away_path_end = 50
            home_path_start = 50 + home_score_width
            home_path_end = 50
            
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
        
        buildScoringChart: (scoringSVG, teamShortNames, away_period_scores, home_period_scores, away_total_points, home_total_points, color = 'primary') ->
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
                    
                path_strings = this.buildPeriodScoringPathStrings away_period_scores[index], home_period_scores[index], multiplier, vertical_start, bar_height
                
                away_path = SVGBuilder.createSVGPath path_strings.away, teamShortNames.away + ' ' + color
                away_text = SVGBuilder.createSVGText away_period_scores[index], "end", 48, (vertical_start + bar_height/2), teamShortNames.away
                
                home_path = SVGBuilder.createSVGPath path_strings.home, teamShortNames.home + ' ' + color
                home_text = SVGBuilder.createSVGText home_period_scores[index], "start", 52, (vertical_start + bar_height/2), teamShortNames.home
                
                scoringSVG.appendChild away_path
                scoringSVG.appendChild home_path
                scoringSVG.appendChild away_text
                scoringSVG.appendChild home_text
                
        buildBasketsPathStrings: (attempts, makes, multiplier, horizontal_start, bar_width) ->   
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
                label_position: 100 - (attempts * multiplier) - 5 # Subtract this 5 to add a little distance between top of bar and label
                misses:
                    path_string: misses_path_string
                    vertical_center: 100 - makes_height - misses_height/2
                makes:
                    path_string: makes_path_string
                    vertical_center: 100 - makes_height/2
            }
                
        buildBasketsChart: (svg, teamShortNames, away, home, bar_width) ->
            max_attempts = Math.max away.attempts, home.attempts
            multiplier = 90/max_attempts
            away_bar_start = (50 - bar_width)/2
            home_bar_start = 100 - away_bar_start - bar_width
            path_strings =
                away: this.buildBasketsPathStrings away.attempts, away.makes, multiplier, away_bar_start, bar_width
                home: this.buildBasketsPathStrings home.attempts, home.makes, multiplier, home_bar_start, bar_width
            
            away_attempts_text = SVGBuilder.createSVGText(
                away.attempts + ' attempts',
                'middle',
                away_bar_start + bar_width/2
                path_strings.away.label_position
            )
            svg.appendChild away_attempts_text
            
            if away.attempts - away.makes > 0
                away_misses_path = SVGBuilder.createSVGPath path_strings.away.misses.path_string, teamShortNames.away + ' secondary'
                away_misses_text = SVGBuilder.createSVGText(
                        (away.attempts - away.makes) + ' misses',
                        'middle',
                        away_bar_start + bar_width/2,
                        path_strings.away.misses.vertical_center,
                        teamShortNames.away
                )
                svg.appendChild away_misses_path
                svg.appendChild away_misses_text
            
            if away.makes > 0
                away_makes_path = SVGBuilder.createSVGPath path_strings.away.makes.path_string, teamShortNames.away
                away_makes_text = SVGBuilder.createSVGText(
                        away.makes + ' makes',
                        'middle',
                        away_bar_start + bar_width/2,
                        path_strings.away.makes.vertical_center,
                        teamShortNames.away + ' primary'
                )
                svg.appendChild away_makes_path
                svg.appendChild away_makes_text
            
            home_attempts_text = SVGBuilder.createSVGText(
                home.attempts + ' attempts',
                'middle',
                home_bar_start + bar_width/2
                path_strings.home.label_position
            )
            svg.appendChild home_attempts_text
            
            if home.attempts - home.makes > 0
                home_misses_path = SVGBuilder.createSVGPath path_strings.home.misses.path_string, teamShortNames.home + ' secondary'
                home_misses_text = SVGBuilder.createSVGText(
                        (home.attempts - home.makes) + ' misses',
                        'middle',
                        home_bar_start + bar_width/2,
                        path_strings.home.misses.vertical_center,
                        teamShortNames.home
                )
                svg.appendChild home_misses_path
                svg.appendChild home_misses_text
            
            if home.makes > 0
                home_makes_path = SVGBuilder.createSVGPath path_strings.home.makes.path_string, teamShortNames.home
                home_makes_text = SVGBuilder.createSVGText(
                        home.makes + ' makes',
                        'middle',
                        home_bar_start + bar_width/2,
                        path_strings.home.makes.vertical_center,
                        teamShortNames.home + ' primary'
                )
                svg.appendChild home_makes_path
                svg.appendChild home_makes_text
        
        buildDeviationChartAxis: (highest, lowest, multiplier) ->
            rounded_highest = this.round highest, 0
            rounded_lowest = this.round lowest, 0
            rounded_middle = (rounded_highest + rounded_lowest)/2
            highest_point = 8 - (rounded_highest - highest)
            lowest_point = 92 - (rounded_lowest - lowest)
            middle_point = (highest_point + lowest_point)/2
            return {
                highest:
                    point: highest_point 
                    value: rounded_highest
                high_middle:
                    point: (highest_point + middle_point)/2
                    value: (rounded_highest + rounded_middle)/2
                middle:
                    point: middle_point
                    value: rounded_middle
                low_middle:
                    point: (middle_point + lowest_point)/2
                    value: (rounded_middle + rounded_lowest)/2
                lowest:
                    point: lowest_point 
                    value: rounded_lowest
            }
        
        buildDeviationPoints: (away_stats, home_stats, radius) ->
            spread = 84 # The range between the lowest point on the chart and the highest, in percent of total SVG height
            highest = Math.max(
                away_stats.this_game, away_stats.avg_per_game, away_stats.opponent_avg_allowed, home_stats.this_game, home_stats.avg_per_game, home_stats.opponent_avg_allowed
            )
            lowest = Math.min(
                away_stats.this_game, away_stats.avg_per_game, away_stats.opponent_avg_allowed, home_stats.this_game, home_stats.avg_per_game, home_stats.opponent_avg_allowed
            )
            difference = highest - lowest
            multiplier = spread/difference
            away_graph_horizontal_position = 30
            home_graph_horizontal_position = 70
            
            return {
                labels: this.buildDeviationChartAxis highest, lowest, multiplier
                points:
                    away:
                        opponent_avg_allowed:
                            path: [away_graph_horizontal_position, 100 - ((away_stats.opponent_avg_allowed * multiplier) - (lowest * multiplier) + 8), radius]
                            value: this.round away_stats.opponent_avg_allowed, 1
                        avg_per_game:
                            path: [away_graph_horizontal_position, 100 - ((away_stats.avg_per_game * multiplier) - (lowest * multiplier) + 8), radius]
                            value: this.round away_stats.avg_per_game, 1
                        this_game:
                            path: [away_graph_horizontal_position, 100 - ((away_stats.this_game * multiplier) - (lowest * multiplier) + 8), radius]
                            value: this.round away_stats.this_game, 1
                        
                    home:
                        opponent_avg_allowed:
                            path: [home_graph_horizontal_position, 100 - ((home_stats.opponent_avg_allowed * multiplier) - (lowest * multiplier) + 8), radius]
                            value: this.round home_stats.opponent_avg_allowed, 1
                        avg_per_game:
                            path: [home_graph_horizontal_position, 100 - ((home_stats.avg_per_game * multiplier) - (lowest * multiplier) + 8), radius]
                            value: this.round home_stats.avg_per_game, 1
                        this_game:
                            path: [home_graph_horizontal_position, 100 - ((home_stats.this_game * multiplier) - (lowest * multiplier) + 8), radius]
                            value: this.round home_stats.this_game, 1
            }
            
        buildDeviationChart: (svg, teamShortNames, away_stats, home_stats) ->
            
            deviation_data = this.buildDeviationPoints away_stats, home_stats, 8
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
                    
            for key, label of deviation_data.labels
                this_label = SVGBuilder.createSVGText label.value, 'start', 0, label.point
                svg.appendChild this_label
        
        buildDeviationLegend: (svg) ->
            icons_and_labels = [
                SVGBuilder.createSVGTriangle 5, 10, 8, 8
                SVGBuilder.createSVGText 'This Game', 'start', 9, 10, 'legend'
                SVGBuilder.createSVGCircle 30, 10, 4
                SVGBuilder.createSVGText 'Avg. Per Game', 'start', 35, 10, 'legend'
                SVGBuilder.createSVGRect 60, 10, 8, 8
                SVGBuilder.createSVGText 'Opp. Avg. Allowed', 'start', 66, 10, 'legend'
            ]
            svg.appendChild element for element in icons_and_labels
            
        getLeaders: (players, stat) ->
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
                    
        buildPieChart: (svg, teamShortName, width, players, total_points, stat, color = 'primary') ->
            leaders = this.getLeaders players, stat
            return if leaders.length is 0
            radian_converter = (2*Math.PI)/total_points 
            next_starting_point =
                x: 100 - (100 - width)/2
                y: 50
            last_angle = 0
            
            if leaders.length is 1
                # Just do a whole circle if there's only one player on the board.
                leader = leaders[0]
                arc = SVGBuilder.createSVGCircle 50, 50, width/2, teamShortName + ' ' + color
                label_spot =
                    x: 50 + ((width/2.2) * Math.cos(Math.PI))
                    y: 50 # Will always be halfway down the chart if using one whole circle
                line_slope =
                    x: (label_spot.x - 50)/5
                    y: (label_spot.y - 50)/5
                line = SVGBuilder.createSVGLine label_spot.x, label_spot.y, label_spot.x + line_slope.x, label_spot.y + line_slope.y, .25
                label_anchor = 'end'
                label = SVGBuilder.createSVGText leader.name + ', ' + leader.value, label_anchor, label_spot.x + line_slope.x, label_spot.y + line_slope.y, 'legend'
                svg.appendChild arc
                svg.appendChild line
                svg.appendChild label
            else
                for leader, index in leaders
                    angle = last_angle + (radian_converter * leader.value)
                    
                    # If this "slice" is more than half of the "pie", need to take special measures to get the arc to work correctly
                    if angle - last_angle > Math.PI
                        interval_point =
                            x: 50 + ((width/2) * Math.cos(last_angle + Math.PI))
                            y: 50 + ((width/2) * Math.sin(last_angle + Math.PI))
                        ending_point =
                            x: 50 + ((width/2) * Math.cos(angle))
                            y: 50 + ((width/2) * Math.sin(angle))
                        arc_string = ' A ' + (width/2) + ' ' + (width/2) + ', 0, 0, 1, ' + interval_point.x + ' ' + interval_point.y +
                            ' A ' + (width/2) + ' ' + (width/2) + ', 0, 0, 1, ' + ending_point.x + ' ' + ending_point.y
                    else
                        ending_point =
                            x: 50 + ((width/2) * Math.cos(angle))
                            y: 50 + ((width/2) * Math.sin(angle))
                        arc_string = ' A ' + (width/2) + ' ' + (width/2) + ', 0, 0, 1, ' + ending_point.x + ' ' + ending_point.y
                        
                    path_string = 'M' + next_starting_point.x + ' ' + next_starting_point.y + arc_string + ' L50 50 Z'
                    arc = SVGBuilder.createSVGPath path_string, teamShortName + ' ' + color
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
                
        buildBarGraph: (svg, teamShortName, players, bar_height, color = 'primary') ->
            bar_width = 80/players.length
            max_value = 0
            for player in players
                max_value = player.value if player.value > max_value
            height_multiplier = bar_height/max_value
            for player, index in players
                height = bar_height - (player.value * height_multiplier)
                path_string = 'M' + (bar_width * index) + ' ' + bar_height + ' L' + (bar_width * index) + ' ' + height +
                    ' L' + (bar_width * (index + 1)) + ' ' + height + ' L' + (bar_width * (index + 1)) + ' ' + bar_height + ' Z'
                bar = SVGBuilder.createSVGPath path_string, teamShortName + ' ' + color
                label = SVGBuilder.createSVGText(
                    player.name + ', ' + player.label,
                    'start',
                    (bar_width * (index + .5)), # X-anchor is in center of corresponding bar
                    bar_height + 2, # Y-anchor is just below bottom of bar 
                    'legend',
                    'rotate(50 ' + (bar_width * (index + .5)) + ',' + (bar_height + 2) + ')'
                )
                svg.appendChild bar
                svg.appendChild label
        
    }