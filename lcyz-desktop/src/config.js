const defaultConfig = {
  // appName: '良车驿站',
  // appName: '选个车',
  appName: '车来客-帮卖版',
  serverUrl: 'http://prime.lina.che3bao.com:7878',
  basePath: '/api/v1',
  staticUrl: 'http://oss-playground.che3bao.com',
  ossUrl: 'http://tianche-playground.oss-cn-hangzhou.aliyuncs.com'
}

const config = {}

config.development = {
  ...defaultConfig,
  serverUrl: process.env.SERVER_URL || defaultConfig.serverUrl,
}

config.production = {
  ...defaultConfig,
  serverUrl: 'http://bm_server.chelaike.cn',
  basePath: '/api/v1',
  staticUrl: 'http://image.chelaike.com',
  ossUrl: 'http://prime.oss-cn-hangzhou.aliyuncs.com',
}

config.xuangeche = {
  ...config.production,
  appName: '选个车',
}

config.lcyz = {
  ...defaultConfig,
  appName: '良车驿站',
  serverUrl: 'http://lc_server.chelaike.cn',
  staticUrl: 'http://lcyz-prime.oss-cn-hangzhou.aliyuncs.com',
  ossUrl: 'http://lcyz-prime.oss-cn-hangzhou.aliyuncs.com',
}

export default config[process.env.STAGE]
