gulp = require 'gulp'
jade = require 'gulp-jade'
connect = require 'gulp-connect'
stylus = require 'gulp-stylus'
coffee = require 'gulp-coffee'
uglify = require('gulp-uglify-es').default
clean = require 'gulp-clean'
rollup = require 'gulp-rollup'
copy = require 'gulp-copy'
sourcemaps = require 'gulp-sourcemaps'


gulp.task 'assets', ->
	gulp.src 'assets/**/*.*'
		.pipe copy 'dist/', prefix: 1

gulp.task 'connect', ->
	connect.server
		port: 3000
		livereload: on
		root: './dist'

gulp.task 'jade', (done) ->
	gulp.src 'jade/*.jade'
		.pipe jade()
			.on 'error', console.log
		.pipe gulp.dest 'dist'
		.pipe do connect.reload

gulp.task 'stylus', (done) ->
	gulp.src 'stylus/*.styl'
		.pipe stylus(compress: on)
			.on 'error', console.log
		.pipe gulp.dest 'dist/css'
		.pipe do connect.reload

gulp.task 'build', (done) ->
	gulp.src 'coffee/**/*.coffee'
		.pipe do sourcemaps.init
		.pipe coffee()
			.on 'error', console.log
		.pipe rollup(
			input: 'coffee/main.js'
			output:
				format: 'cjs'
				intro: '(function(){'
				outro: '})();'
			).on 'error', console.log
		.pipe uglify()
			.on 'error', console.log
		.pipe do sourcemaps.write
		.pipe gulp.dest 'dist/js'
		.pipe do connect.reload

	gulp.src 'coffee/**/*.js', read: no
		.pipe do clean

gulp.task 'watch', ->
	gulp.watch 'jade/**/*.jade', ['jade']
	gulp.watch 'stylus/**/*.styl', ['stylus']
	gulp.watch 'coffee/**/*.coffee', ['build']
	gulp.watch 'assets/**/*.*', ['assets']

gulp.task 'default', [
	'assets',
	'jade',
	'stylus',
	'build',
	'connect',
	'watch'
]