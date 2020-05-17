// Webpack config for creating the production bundle.
require('babel-register')
var path = require('path');
var webpack = require('webpack');
var strip = require('strip-loader');
var CleanPlugin = require('clean-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin')
var CopyWebpackPlugin = require('copy-webpack-plugin');
var autoprefixer = require('autoprefixer')
var config = require('../src/config').default

var relativeAssetsPath = './dist';

var htmlTemplate = './src/index.html';

if (process.env.STAGE === 'staging') {
  htmlTemplate = './src/index.staging.html';
} else {
  htmlTemplate = './src/index.prod.html';
}

var extractCSS = new ExtractTextPlugin('[name]0-[chunkhash].css', { allChunks: true });
var extractSASS = new ExtractTextPlugin('[name]1-[chunkhash].css', { allChunks: true });

module.exports = {
  devtool: false,
  context: path.resolve(__dirname, '..'),
  entry: {
    'main': './src/index.js'
  },
  output: {
    path: relativeAssetsPath,
    filename: '[name]-[chunkhash].js',
    chunkFilename: '[name]-[chunkhash].js',
    publicPath: '/'
  },
  module: {
    loaders: [
      { test: require.resolve("jquery"), loader: "expose?$!expose?jQuery" },
      { test: /\.js$/, exclude: /(node_modules|semantic\/)/, loaders: [strip.loader('debug'), 'babel']},
      { test: /\.json$/, loader: 'json-loader' },
      { test: /\.(css|less)/, loader: extractCSS.extract('style', 'css!less')},
      { test: /\.scss$/, loader: extractSASS.extract('style', 'css?modules&importLoaders=2!postcss!sass?outputStyle=expanded') },
      { test: /\.woff(\?.+?)?$/, loader: "url?limit=10000&mimetype=application/font-woff" },
      { test: /\.woff2(\?.*?)?$/, loader: "url?limit=10000&mimetype=application/font-woff" },
      { test: /\.ttf(\?.*?)?$/, loader: "url?limit=10000&mimetype=application/octet-stream" },
      { test: /\.eot(\?.*?)?$/, loader: "file" },
      { test: /\.svg(\?.*?)?$/, loader: "url?limit=10000&mimetype=image/svg+xml" },
      { test: /\.(jpe?g|png|gif|svg)$/, loader: 'url-loader?limit=10240' },
      { test: /\.swf$/, loader: "file" },
      { test: /\.md$/, loader: "html!markdown" },
    ],
    noParse: [
      /semantic\/dist\/components\/.+$/
    ]
  },
  postcss: function () {
    return [autoprefixer]
  },
  progress: true,
  resolve: {
    root: [
      path.resolve(__dirname, '../src'),
    ],
    extensions: ['', '.json', '.js']
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './src/index.ejs',
      favicon: 'static/favicon.ico',
      baiduAnalytics: config.baiduAnalytics,
    }),

    new CopyWebpackPlugin([
      { from: 'src/upgrade.html' }
    ]),

    new CleanPlugin([relativeAssetsPath]),

    // css files from the extract-text-plugin loader
    extractCSS,
    extractSASS,

    // ignore dev config
    new webpack.IgnorePlugin(/\.\/dev/, /\/config$/),

    // set global vars
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(process.env.NODE_ENV),
        STAGE: JSON.stringify(process.env.STAGE)
      }
    }),

    // optimizations
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      }
    }),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    })
  ]
};
