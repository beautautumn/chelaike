import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('authorities/FETCH', () => ({
  method: 'get',
  endpoint: '/authorities',
}))

const initialState = {}

const reducer = createReducer((on) => {
  on(fetch.success, (state, payload) => ({
    ...state,
    authorities: payload
  }))
}, initialState)

export default reducer
