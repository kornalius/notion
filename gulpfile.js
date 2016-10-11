'use strict'

const gulp = require('gulp')
const es = require('event-stream')
const source = require('vinyl-source-stream')
const browserify = require('browserify')
const glob = require('glob')
const concat = require('gulp-concat')
const babel = require('gulp-babel')
const rename = require('gulp-rename')
const riot = require('gulp-riot')
const browserSync = require('browser-sync')
const historyApiFallback = require('connect-history-api-fallback')

const reload = browserSync.reload

function onError (err) {
  console.error(err.message + '\n' + err.codeFrame)
  this.emit('end')
}

gulp.task('build-js', (done) => {
  glob('./src/index.js', (err, files) => {
    if (err) done(err)

    let tasks = files.map((entry) => {
      return browserify({
          entries: [entry],
          ignoreMissing: true,
          detectGlobals: false,
          debug: true
        })
        .on('error', onError)
        .transform('babelify')
        .on('error', onError)
        .bundle()
        .on('error', onError)
        .pipe(source(entry))
        .on('error', onError)
        .pipe(rename({ dirname: '', }))
        .on('error', onError)
        .pipe(gulp.dest('./build'))
    })

    es.merge(tasks).on('end', done)
  })
})

gulp.task('build-html', (done) => {
  glob('./src/**/*.html', (err, files) => {
    if (err) done(err)

    let tasks = files.map((entry) => {
      return gulp.src(entry)
        .pipe(gulp.dest('./build'))
    })

    es.merge(tasks).on('end', done)
  })
})

gulp.task('build-assets', (done) => {
  let tasks = [
    gulp.src('./assets/**/*')
      .pipe(gulp.dest('./build/assets'))
  ]

  es.merge(tasks).on('end', done)
})

gulp.task('build-semantic', (done) => {
  let tasks = [
    gulp.src('./semantic/dist/semantic.min.*')
      .pipe(gulp.dest('./build/css'))
  ]

  es.merge(tasks).on('end', done)
})

gulp.task('build-riot', ()=> {
  gulp.src('./src/**/*.tag')
      .pipe(riot({
        expr: true,
        type: 'babel',
        template: 'pug',
        parsers: {
          css: 'scss',
          js: 'babel',
          html: 'pug',
        }
      }))
      .pipe(gulp.dest('./build'));
})

gulp.task('watch', () => {
  browserSync({
    notify: false,
    browser: 'google chrome',
    logPrefix: 'NOTION',
    snippetOptions: {
      rule: {
        match: '<span id="browser-sync-binding"></span>',
        fn: snippet => snippet
      }
    },
    // Run as an https by uncommenting 'https: true'
    // Note: this uses an unsigned certificate which on first access
    //       will present a certificate warning in the browser.
    // https: true,
    server: {
      baseDir: ['build'],
      middleware: [ historyApiFallback() ],
      //routes: {
        //'/bower_components': 'bower_components'
      //}
    }
  })
  gulp.watch('./src/**/*.js', { debounceDelay: 500 }, (e) => {
    gulp.start('build-js', reload)
  })
  gulp.watch('./src/**/*.html', { debounceDelay: 500 }, (e) => {
    gulp.start('build-html', reload)
  })
  gulp.watch('./src/**/*.tag', { debounceDelay: 500 }, (e) => {
    gulp.start('build-riot', reload)
  })
  gulp.watch('./assets/**/*', { debounceDelay: 500 }, (e) => {
    gulp.start('build-assets', reload)
  })
})


gulp.task('build-client', ['build-assets', 'build-semantic', 'build-html', 'build-js', 'build-riot'])

gulp.task('build', ['build-client'])

gulp.task('default', ['build', 'watch'], () => {})
