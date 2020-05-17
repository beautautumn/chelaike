var path = require('path');
var webpack = require('webpack');
var autoprefixer = require('autoprefixer')

module.exports = {
  devtool: 'inline-source-map',
  module: {
    loaders: [
      { test: require.resolve("jquery"), loader: "expose?$!expose?jQuery" },
      { test: /\.js$/, exclude: /(node_modules|semantic\/)/, loader: "babel" },
      { test: /\.json$/, loader: 'json-loader' },
      { test: /\.css/, loader: 'style!css' },
      { test: /\.scss$/, loader: 'style!css?modules&importLoaders=2&sourceMap&localIdentName=[local]___[hash:base64:5]!postcss!sass?outputStyle=expanded&sourceMap' },
      { test: /\.woff(\?.+?)?$/, loader: "null" },
      { test: /\.woff2(\?.*?)?$/, loader: "null" },
      { test: /\.ttf(\?.*?)?$/, loader: "null" },
      { test: /\.eot(\?.*?)?$/, loader: "null" },
      { test: /\.svg(\?.*?)?$/, loader: "null" },
      { test: /\.(jpe?g|png|gif|svg)$/, loader: "null" },
      { test: /\.swf$/, loader: "null" }
    ],
    noParse: [
      /semantic\/dist\/components\/.+$/
    ]
  },
  postcss: function () {
    return [autoprefixer]
  },
  externals: {
    'cheerio': 'window',
    'react/lib/ExecutionEnvironment': true,
    'react/lib/ReactContext': true
  },
  resolve: {
    root: [
      path.resolve(__dirname, '../src'),
    ],
    extensions: ['', '.json', '.js']
  },
  plugins: [
    new webpack.IgnorePlugin(/\.json$/),
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(process.env.NODE_ENV)
      }
    }),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    })
  ]
};
