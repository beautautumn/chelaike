var webpackConfig = require('./webpack/test.config');

module.exports = function (config) {
  config.set({

    browsers: [ 'PhantomJS' ],

    frameworks: [ 'mocha' ],

    files: [
      './node_modules/phantomjs-polyfill/bind-polyfill.js',
      'tests.webpack.js'
    ],

    preprocessors: {
      'tests.webpack.js': [ 'webpack', 'sourcemap' ]
    },

    reporters: [ 'mocha' ],

    plugins: [
      require("karma-webpack"),
      require("karma-mocha"),
      require("karma-mocha-reporter"),
      require("karma-phantomjs-launcher"),
      require("karma-sourcemap-loader"),
      require("karma-osx-reporter")
    ],

    webpack: webpackConfig,

    webpackServer: {
      noInfo: true
    }

  });
};
