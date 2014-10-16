scorevision.controller "GameController", ($http, $timeout, $scope, SVGBuilder, ChartBuilder) ->
    
    renderAllGraphs = (response, status, headers, config) ->
        # TODO: Add exception for 76ers -> sixers
        
        $scope.away_full_name = response.box_score.away_team.full_name
        $scope.away_final_score = response.box_score.away_totals.points
        
        $scope.home_full_name = response.box_score.home_team.full_name
        $scope.home_final_score = response.box_score.home_totals.points
        
        $scope.team_nicknames =
            away: response.box_score.away_team.last_name.toLowerCase()
            home: response.box_score.home_team.last_name.toLowerCase()
            
        $scope.team_nicknames.away = 'sixers' if $scope.team_nicknames.away is '76ers'
        $scope.team_nicknames.home = 'sixers' if $scope.team_nicknames.home is '76ers'
        
        $scope.team_short_names =
            away: response.box_score.away_team.abbreviation
            home: response.box_score.home_team.abbreviation
        
        # Scoring
        
        ChartBuilder.buildScoringChart(
            document.getElementById('scoring-by-period'),
            $scope.team_nicknames,
            response.box_score.away_period_scores,
            response.box_score.home_period_scores,
            response.box_score.away_totals.points,
            response.box_score.home_totals.points
        )
        
        # Field goals
        
        ChartBuilder.buildBasketsChart(
            document.getElementById('field-goals'),
            $scope.team_nicknames,
            {
                attempts: response.box_score.away_totals.field_goals_attempted
                makes: response.box_score.away_totals.field_goals_made
            },
            {
                attempts: response.box_score.home_totals.field_goals_attempted
                makes: response.box_score.home_totals.field_goals_made
            },
            30
        )
        
        # Free throws
        
        ChartBuilder.buildBasketsChart(
            document.getElementById('free-throws'),
            $scope.team_nicknames,
            {
                attempts: response.box_score.away_totals.free_throws_attempted
                makes: response.box_score.away_totals.free_throws_made
            },
            {
                attempts: response.box_score.home_totals.free_throws_attempted
                makes: response.box_score.home_totals.free_throws_made
            },
            30
        )
        
        # 3 pointers
        
        ChartBuilder.buildBasketsChart(
            document.getElementById('3-pointers'),
            $scope.team_nicknames,
            {
                attempts: response.box_score.away_totals.three_point_field_goals_attempted
                makes: response.box_score.away_totals.three_point_field_goals_made
            },
            {
                attempts: response.box_score.home_totals.three_point_field_goals_attempted
                makes: response.box_score.home_totals.three_point_field_goals_made
            },
            30
        )
        
        # Score deviation
        
        deviationLegends =  document.querySelectorAll('svg.legend')
        for legend in deviationLegends
            ChartBuilder.buildDeviationLegend legend
        
        away_score_data =
            this_game: response.box_score.away_totals.points
            avg_per_game: parseFloat response.away_team_stats.team_stats[0].stats.points_per_game_string
            opponent_avg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.points_per_game_string
        home_score_data =
            this_game: response.box_score.home_totals.points
            avg_per_game: parseFloat response.home_team_stats.team_stats[0].stats.points_per_game_string
            opponent_avg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.points_per_game_string
        
        ChartBuilder.buildDeviationChart document.getElementById('score-deviation'), $scope.team_nicknames, away_score_data, home_score_data
        
        # Field goal percent deviation
        
        away_fg_data =
            this_game: response.box_score.away_totals.field_goal_percentage * 100
            avg_per_game: parseFloat response.away_team_stats.team_stats[0].stats.field_goal_percentage * 100
            opponent_avg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.field_goal_percentage * 100
        home_fg_data =
            this_game: response.box_score.home_totals.field_goal_percentage * 100
            avg_per_game: parseFloat response.home_team_stats.team_stats[0].stats.field_goal_percentage * 100
            opponent_avg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.field_goal_percentage * 100
        
        ChartBuilder.buildDeviationChart document.getElementById('field-goal-percent-deviation'), $scope.team_nicknames, away_fg_data, home_fg_data
        
        # 3pt percent deviation
        
        away_3pt_data =
            this_game: response.box_score.away_totals.three_point_percentage * 100
            avg_per_game: parseFloat response.away_team_stats.team_stats[0].stats.three_point_percentage * 100
            opponent_avg_allowed: parseFloat response.home_team_stats.team_stats[0].stats_opponent.three_point_percentage * 100
        home_3pt_data =
            this_game: response.box_score.home_totals.three_point_percentage * 100
            avg_per_game: parseFloat response.home_team_stats.team_stats[0].stats.three_point_percentage * 100
            opponent_avg_allowed: parseFloat response.away_team_stats.team_stats[0].stats_opponent.three_point_percentage * 100
        
        ChartBuilder.buildDeviationChart document.getElementById('3pt-percent-deviation'), $scope.team_nicknames, away_3pt_data, home_3pt_data
        
        # Individual scoring
        
        ChartBuilder.buildPieChart(
            document.getElementById('individual-scoring-away'),
            $scope.team_nicknames.away,
            60,
            response.box_score.away_stats,
            response.box_score.away_totals.points,
            'points',
        )
        
        ChartBuilder.buildPieChart(
            document.getElementById('individual-scoring-home'),
            $scope.team_nicknames.home,
            60,
            response.box_score.home_stats,
            response.box_score.home_totals.points,
            'points'
        )
        
        # Individual rebounding
        
        ChartBuilder.buildPieChart(
            document.getElementById('individual-rebounding-away'),
            $scope.team_nicknames.away,
            60,
            response.box_score.away_stats,
            response.box_score.away_totals.rebounds,
            'rebounds'
        )
        
        ChartBuilder.buildPieChart(
            document.getElementById('individual-rebounding-home'),
            $scope.team_nicknames.home,
            60,
            response.box_score.home_stats,
            response.box_score.home_totals.rebounds,
            'rebounds'
        )
        
        # Individual assists
        
        ChartBuilder.buildPieChart(
            document.getElementById('individual-assists-away'),
            $scope.team_nicknames.away,
            60,
            response.box_score.away_stats,
            response.box_score.away_totals.assists,
            'assists'
        )
        
        ChartBuilder.buildPieChart(
            document.getElementById('individual-assists-home'),
            $scope.team_nicknames.home,
            60,
            response.box_score.home_stats,
            response.box_score.home_totals.assists,
            'assists'
        )
        
        # Individual steals
        
        ChartBuilder.buildPieChart(
            document.getElementById('individual-steals-away'),
            $scope.team_nicknames.away,
            60,
            response.box_score.away_stats,
            response.box_score.away_totals.steals,
            'steals'
        )
        
        ChartBuilder.buildPieChart(
            document.getElementById('individual-steals-home'),
            $scope.team_nicknames.home,
            60,
            response.box_score.home_stats,
            response.box_score.home_totals.steals,
            'steals'
        )
        
        # Scoring Efficiency
        
        player_efficiencies =
            away:
                scoring: []
                rebounding: []
            home:
                scoring: []
                rebounding: []
        for player in response.box_score.away_stats
            if player.minutes > 5
                display_name = player.first_name[0] + '. ' + player.last_name
                player_efficiencies.away.scoring.push {
                    name: display_name
                    value: player.points/player.minutes
                    label: player.points + 'pts/' + player.minutes + 'min'
                }
                player_efficiencies.away.rebounding.push {
                    name: display_name
                    value: player.rebounds/player.minutes
                    label: player.rebounds + 'reb/' + player.minutes + 'min'
                }
                
        ChartBuilder.buildBarGraph(
            document.getElementById('scoring-efficiency-away'),
            $scope.team_nicknames.away,
            player_efficiencies.away.scoring,
            70,
            'secondary'
        )
        
        ChartBuilder.buildBarGraph(
            document.getElementById('rebounding-efficiency-away'),
            $scope.team_nicknames.away,
            player_efficiencies.away.rebounding,
            70,
            'secondary'
        )
        
        for player in response.box_score.home_stats
            if player.minutes > 5
                display_name = player.first_name[0] + '. ' + player.last_name
                player_efficiencies.home.scoring.push {
                    name: player.first_name[0] + '. ' + player.last_name
                    value: player.points/player.minutes
                    label: player.points + 'pts/' + player.minutes + 'min'
                }
                player_efficiencies.home.rebounding.push {
                    name: display_name
                    value: player.rebounds/player.minutes
                    label: player.rebounds + 'reb/' + player.minutes + 'min'
                }
                
        ChartBuilder.buildBarGraph(
            document.getElementById('scoring-efficiency-home'),
            $scope.team_nicknames.home,
            player_efficiencies.home.scoring,
            70,
            'secondary'
        )
        
        ChartBuilder.buildBarGraph(
            document.getElementById('rebounding-efficiency-home'),
            $scope.team_nicknames.home,
            player_efficiencies.home.rebounding,
            70,
            'secondary'
        )

        
    dataError = ->
    
    $http.get('/data' + location.pathname)
        .success((data, status, headers, config) -> renderAllGraphs data, status, headers, config)
        .error((data, status, headers, config) -> dataError data, status, headers, config)