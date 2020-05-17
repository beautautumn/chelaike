const defaultConfig = {
  appName: '启辕CRM',
  serverUrl: 'http://mobile.anpxd.com',
  // serverUrl: 'http://prime.lina.che3bao.com:8686',
  basePath: '/api/v1',
  staticUrl: 'http://env-dev.oss-cn-beijing.aliyuncs.com',
  ossUrl: 'http://env-dev.oss-cn-beijing.aliyuncs.com'
}

const config = {}

config.development = {
  ...defaultConfig,
}

config.staging = {
  ...defaultConfig,
}

config.production = {
  ...defaultConfig,
  serverUrl: 'http://mobile.anpxd.com',
  staticUrl: 'http://image.anpxd.com',
  ossUrl: 'http://image.anpxd.com',
  baiduAnalytics: {
    trackingId: '52e59a5de70a3ee13c5fbc4cff865a61',
  },
}

export default config[process.env.STAGE]
