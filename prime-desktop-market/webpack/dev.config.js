var path = require('path');
var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var assetsPath = path.resolve(__dirname, '../dist')
var autoprefixer = require('autoprefixer')

module.exports = {
  devtool: 'eval-source-map',
  context: path.resolve(__dirname, '..'),
  entry: {
    'main': [
      'webpack-hot-middleware/client',
      './src/index.js'
    ]
  },
  output: {
    path: assetsPath,
    filename: '[name]-[hash].js',
    chunkFilename: '[name]-[chunkhash].js',
    publicPath: '/',
    pathinfo: true
  },
  module: {
    loaders: [
      { test: require.resolve("jquery"), loader: "expose?$!expose?jQuery" },
      { test: /\.js$/, exclude: /(node_modules|semantic\/)/, loaders: ['babel?cacheDirectory', 'eslint']},
      { test: /\.json$/, loader: 'json-loader' },
      { test: /\.(css|less)/, loader: ExtractTextPlugin.extract('style', 'css!less')},
      { test: /\.scss$/, loader: 'style!css?modules&importLoaders=2&sourceMap&localIdentName=[local]___[hash:base64:5]!postcss!sass?outputStyle=expanded&sourceMap' },
      { test: /\.woff(\?.+?)?$/, loader: "url?limit=10000&mimetype=application/font-woff" },
      { test: /\.woff2(\?.*?)?$/, loader: "url?limit=10000&mimetype=application/font-woff" },
      { test: /\.ttf(\?.*?)?$/, loader: "url?limit=10000&mimetype=application/octet-stream" },
      { test: /\.eot(\?.*?)?$/, loader: "file" },
      { test: /\.svg(\?.*?)?$/, loader: "url?limit=10000&mimetype=image/svg+xml" },
      { test: /\.(jpe?g|png|gif|svg)$/, loader: 'url?limit=10240' },
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
      favicon: 'static/favicon.ico'
    }),
    new ExtractTextPlugin('[name]-[chunkhash].css', {allChunks: true}),
    // hot reload
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(process.env.NODE_ENV),
        STAGE: JSON.stringify(process.env.STAGE),
        SERVER_URL: JSON.stringify(process.env.SERVER_URL),
      }
    }),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    })
  ]
};
