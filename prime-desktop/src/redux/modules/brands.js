import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('brands/FETCH', (query = {}) => ({
  method: 'get',
  endpoint: query.stateType ? '/cars/brands' : '/brands',
  query,
}))

const initialState = {
  data: [],
  fetching: false,
  fetched: false
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetching: true,
  }))

  on(fetch.success, (state, payload) => ({
    ...state,
    data: payload,
    fetching: false,
    fetched: true
  }))
}, initialState)

export default reducer
