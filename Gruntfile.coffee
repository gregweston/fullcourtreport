module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        watch:
            coffeeFrontEnd:
                files: './coffee/frontend/**/*.coffee'
                tasks: ['coffee:compileFrontEnd', 'concat']
            coffeeRoutes:
                files: './coffee/backend/routes.coffee'
                tasks: ['coffee:compileRoutes']
            coffeeModules:
                files: './coffee/backend/modules/*.coffee'
                tasks: ['coffee:compileModules']
            coffeeApp:
                files: './coffee/backend/app.coffee'
                tasks: ['coffee:compileApp']
            sass:
                files: './sass/*.sass'
                tasks: ['sass']
        coffee:
            compileFrontEnd:
                expand: true
                flatten: false
                src: './coffee/frontend/**/*.coffee'
                dest: './coffee/frontend/compiled/'
                ext: '.js'
            compileRoutes:
                options:
                    bare: true
                expand: true
                flatten: true
                src: ['./coffee/backend/routes.coffee']
                dest: './'
                ext: '.js'
            compileModules:
                options:
                    bare: true
                expand: true
                flatten: true
                src: ['./coffee/backend/modules/*.coffee']
                dest: './modules/'
                ext: '.js'
            compileApp:
                options:
                    bare: true
                files:
                    './app.js': ['./coffee/backend/app.coffee']
        sass:
            dist:
                options:
                    style: 'compressed'
                files:
                    './public/css/compiled/app.css': './sass/app.sass'
        concat:
            dist:
                src:[
                    './coffee/frontend/compiled/coffee/frontend/classes/SVGBuilder.js'
                    './coffee/frontend/compiled/coffee/frontend/superscore.js'
                ]
                dest:
                    './public/js/compiled/app.js'
        uglify:
            dist:
                options:
                    mangle: false
                files: [{
                    expand: true
                    cwd: './public/js/compiled/'
                    src: '**/*.js'
                    dest: './public/js/compiled/'
                }]
    grunt.registerTask 'default', ['sass', 'coffee', 'concat', 'uglify']