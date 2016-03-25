gulp = require 'gulp'
jade = require 'gulp-jade'
sass = require 'gulp-sass'
coffee = require 'gulp-coffee'
server = require 'gulp-develop-server'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'

DEST = './dist/'

gulp.task 'jade', ->
  gulp.src './src/**/*.jade'
    .pipe jade()
    .pipe gulp.dest DEST

gulp.task 'sass', ->
  gulp.src './src/**/*.sass'
    .pipe sass()
    .pipe gulp.dest DEST

gulp.task 'scripts', ->
  gulp.src './src/**/*.coffee', { read: false }
    .pipe browserify({
        transform: ['coffeeify'],
        extensions: ['.js', '.coffee']
    })
    .pipe rename((path) ->
      path.extname = '.js'
    )
    .pipe gulp.dest DEST

  gulp.src './src/cssTests/script/*.js', { read: false }
    .pipe browserify({
        extensions: ['.js']
    })
    .pipe rename((path) ->
      path.extname = '.js'
    )
    .pipe gulp.dest DEST + '/cssTests/script/'

gulp.task 'server:start', ->
  server.listen {path: './server.coffee'}

gulp.task 'copy', ->
  gulp.src './src/cssTests/css/*'
    .pipe gulp.dest DEST + 'cssTests/css'
  gulp.src './node_modules/font-awesome/fonts/*'
    .pipe gulp.dest DEST + 'fonts/'
  gulp.src './src/tasks/*'
    .pipe gulp.dest DEST + 'tasks/'
    gulp.src './node_modules/jquery-ui/themes/vader/jquery-ui.min.css*'
    .pipe gulp.dest DEST + 'styles/lib/'

gulp.task 'watch', ->
  gulp.watch './src/**/*.jade', ['jade']
  gulp.watch './src/**/*.sass', ['sass']
  gulp.watch './src/**/*.coffee', ['scripts']
  gulp.watch './server.coffee', server.restart

gulp.task 'default', ['jade', 'sass', 'scripts', 'copy', 'server:start', 'watch']
