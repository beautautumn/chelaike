import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('oss/FETCH', () => ({
  method: 'post',
  endpoint: '/oss_configuration',
}))

// 服务器设置的是24小时过期，这里设置成20小时就重新获取下
const expiredTime = 3600 * 20

const initialState = {}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetched: false
  }))

  on(fetch.success, (state, payload) => ({
    ...state,
    ...payload,
    fetched: true,
    expiredAt: Date.now() + expiredTime
  }))
}, initialState)

export default reducer

export function shouldFetch(state) {
  return !state.fetched || state.expiredAt < Date.now()
}
