import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('enumValues/FETCH', () => ({
  method: 'get',
  endpoint: '~/api/enumerize_locales',
  raw: true,
}))

const initialState = {
  fetched: false
}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload) => ({
    ...state,
    ...payload,
    fetched: true
  }))
}, initialState)

export default reducer
