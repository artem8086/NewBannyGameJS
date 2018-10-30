gulp = require 'gulp'
jade = require 'gulp-jade'
connect = require 'gulp-connect'
stylus = require 'gulp-stylus'
coffee = require 'gulp-coffee'
uglify = require('gulp-uglify-es').default
clean = require 'gulp-clean'
rollup = require 'gulp-rollup'
copy = require 'gulp-copy'

gulp.task 'assets', ->
	gulp.src 'assets/**/*.*'
		.pipe copy '.'
		.pipe gulp.dest 'dist'

gulp.task 'connect', ->
	connect.server
		port: 3000
		livereload: on
		root: './dist'

gulp.task 'jade', ->
	gulp.src 'jade/*.jade'
		.pipe do jade
		.pipe gulp.dest 'dist'
		.pipe do connect.reload

gulp.task 'stylus', ->
	gulp.src 'stylus/*.styl'
		.pipe stylus compress: on
		.pipe gulp.dest 'dist/css'
		.pipe do connect.reload

gulp.task 'build', ['coffee'], ->
	gulp.src 'js/*.js'
		.pipe rollup
			input: 'js/main.js'
			output: format: 'cjs'
		.pipe do uglify
		.pipe gulp.dest 'dist/js'
		.pipe do connect.reload

	gulp.src 'js/', read: no
		.pipe do clean

gulp.task 'coffee', ->
	gulp.src 'coffee/**/*.coffee'
		.pipe do coffee
		.pipe gulp.dest 'js'

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