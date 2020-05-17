const defaultConfig = {
  appName: '车来客市场版CRM',
  serverUrl: 'http://prime-market.chelaike.com',
  basePath: '/api/v1',
  staticUrl: 'http://prime.oss-cn-hangzhou.aliyuncs.com',
  ossUrl: 'http://prime.oss-cn-hangzhou.aliyuncs.com'
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
  baiduAnalytics: {
    trackingId: '52e59a5de70a3ee13c5fbc4cff865a61',
  },
}

export default config[process.env.STAGE]
