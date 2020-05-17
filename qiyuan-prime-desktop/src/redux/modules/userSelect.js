import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'

export const fetch = createApiAction('userSelect/FETCH', (query = {}) => ({
  method: 'get',
  endpoint: '/users/selector',
  schema: Schemas.USER_ARRAY,
  query,
}))

const initialState = {
  ids: [],
  fetched: false,
  fetching: false
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetching: true
  }))

  on(fetch.success, (state, payload) => ({
    ...state,
    ids: payload.result,
    fetching: false,
    fetched: true
  }))
}, initialState)

export default reducer
