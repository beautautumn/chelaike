const defaultConfig = {
  appName: '车融易',
  serverUrl: 'http://easy-loan.staging.chelaike.com',
  basePath: '/api/v1'
};

const config = {};

config.development = {
  ...defaultConfig,
  serverUrl: process.env.SERVER_URL || defaultConfig.serverUrl
};

config.staging = {
  ...defaultConfig,
  env: 'staging',
  sentry: {
    dsn: 'http://8ded234b670b47eca872249fc8513c28@sentry.chelaike.com/6'
  }
};

config.production = {
  ...defaultConfig,
  env: 'production',
  serverUrl: 'http://easy-loan.chelaike.com',
  sentry: {
    dsn: 'http://e963500c8a6a4c01ab0093cae912c399@sentry.chelaike.com/7'
  },
  baiduAnalytics: {
    trackingId: '52e59a5de70a3ee13c5fbc4cff865a61'
  }
};

export default config[process.env.STAGE];
