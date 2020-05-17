const defaultConfig = {
  appName: '车来客联盟管理后台',
  serverUrl: 'http://prime.lina.che3bao.com',
  basePath: '/api/v1/alliance_dashboard',
  staticUrl: 'http://oss-playground.che3bao.com',
  ossUrl: 'http://tianche-playground.oss-cn-hangzhou.aliyuncs.com',
}

const config = {}

config.development = {
  ...defaultConfig,
  serverUrl: process.env.SERVER_URL || defaultConfig.serverUrl,
}

config.staging = {
  ...defaultConfig,
  sentry: {
    dsn: 'http://c0ef56ad02ff43f4ac467f4c0a6852a0@sentry.chelaike.com/5',
  },
}

config.production = {
  ...defaultConfig,
  serverUrl: 'http://server.chelaike.com',
  basePath: '/api/v1/alliance_dashboard',
  staticUrl: 'http://image.chelaike.com',
  ossUrl: 'http://prime.oss-cn-hangzhou.aliyuncs.com',
  sentry: {
    dsn: 'http://48e813bdc1264b79a709b8952e114bd0@sentry.chelaike.com/4',
  },
}

export default config[process.env.STAGE]
