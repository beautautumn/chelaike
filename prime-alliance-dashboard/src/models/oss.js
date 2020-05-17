import feeble from 'feeble'

// 服务器设置的是24小时过期，这里设置成20小时就重新获取下
const EXPIRED_TIME = 3600 * 20

const model = feeble.model({
  namespace: 'oss',
  state: {
    fetched: false,
  },
})

model.apiAction('fetch', () => ({
  method: 'post',
  endpoint: '/oss_configuration',
}))

model.reducer(on => {
  on(model.fetch.request, state => ({
    ...state,
    fetched: false,
  }))

  on(model.fetch.success, (state, payload) => ({
    ...state,
    ...payload,
    fetched: true,
    expiredAt: Date.now() + EXPIRED_TIME,
  }))
})

export default model

export function shouldFetch(state) {
  return !state.fetched || state.expiredAt < Date.now()
}
