import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('cities/FETCH', province => ({
  method: 'get',
  endpoint: '/regions/cities',
  query: {
    province: { name: province }
  },
}), (province, key) => ({
  key,
}))

const initialState = {}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload, meta) => ({
    ...state,
    [meta.key]: payload,
  }))
}, initialState)

export default reducer
