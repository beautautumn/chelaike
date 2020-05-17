process.env.NODE_ENV = process.env.NODE_ENV || 'development';
process.env.STAGE = process.env.STAGE || 'development';

var Express = require('express');
var webpack = require('webpack');
var historyApiFallback = require("connect-history-api-fallback");

var webpackConfig = require('./dev.config');
var compiler = webpack(webpackConfig);

var host = process.env.HOST || 'localhost';
var port = process.env.PORT || 3001;
var serverOptions = {
  noInfo: true,
  lazy: false,
  historyApiFallback: true,
  headers: { 'Access-Control-Allow-Origin': '*' },
  stats: { colors: true }
};

var app = new Express();

app.use(historyApiFallback());
app.use(require('webpack-dev-middleware')(compiler, serverOptions));
app.use(require('webpack-hot-middleware')(compiler));

app.listen(port, function onAppListening(err) {
  if (err) {
    console.error(err);
  } else {
    console.info('==> 🚧  Webpack development server listening on port %s', port);
  }
});
