const defaultConfig = {
  appName: '车来客',
  downloadUrl: 'd.chelaike.com',
  serverUrl: 'http://prime.lina-server.chelaike.com',
  basePath: '/api/v1',
  staticUrl: 'http://oss-playground.che3bao.com',
  ossUrl: 'http://tianche-playground.oss-cn-hangzhou.aliyuncs.com'
}

const config = {}

config.development = {
  ...defaultConfig,
  serverUrl: process.env.SERVER_URL || defaultConfig.serverUrl,
}

config.staging = {
  ...defaultConfig,
  sentry: {
    dsn: 'http://8ded234b670b47eca872249fc8513c28@sentry.chelaike.com/6',
  },
}

config.chelaike = {
  ...defaultConfig,
  serverUrl: 'http://server.prerelease.chelaike.com',
  staticUrl: 'http://image.chelaike.com',
  ossUrl: 'http://prime.oss-cn-hangzhou.aliyuncs.com',
  oldVersionUrl: 'http://old.chelaike.com',
  sentry: {
    dsn: 'http://e963500c8a6a4c01ab0093cae912c399@sentry.chelaike.com/7',
  },
  baiduAnalytics: {
    trackingId: '52e59a5de70a3ee13c5fbc4cff865a61',
  },
}

config.hongsheng = {
  ...config.chelaike,
  appName: '鸿升车来客',
  downloadUrl: 'hs.chelaike.com',
  oldVersionUrl: 'http://hsold.chelaike.com',
  sentry: {
    dsn: 'http://e963500c8a6a4c01ab0093cae912c399@sentry.chelaike.com/7',
  },
  baiduAnalytics: {
    trackingId: '52e59a5de70a3ee13c5fbc4cff865a61',
  },
}

export default config[process.env.STAGE]
