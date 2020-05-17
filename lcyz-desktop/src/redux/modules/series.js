import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('series/FETCH', (query = {}) => ({
  method: 'get',
  endpoint: query.stateType ? '/cars/series' : '/series',
  query,
}), (query, key) => ({
  key
}))

const initialState = {}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload, meta) => {
    const data = payload.reduce((accumulator, group) => ([
      ...accumulator,
      ...group.series
    ]), [])

    return {
      ...state,
      [meta.key]: data
    }
  })
}, initialState)

export default reducer
