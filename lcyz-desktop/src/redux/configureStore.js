if (process.env.NODE_ENV !== 'development') {
  module.exports = require('./configureStore.prod') // eslint-disable-line
} else {
  module.exports = require('./configureStore.dev') // eslint-disable-line
}
