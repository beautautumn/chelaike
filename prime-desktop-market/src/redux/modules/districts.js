import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'

export const fetch = createApiAction('districts/FETCH', cityName => ({
  method: 'get',
  endpoint: '/regions/districts',
  query: {
    city: { name: cityName }
  },
  schema: Schemas.DISTRICT_ARRAY,
}))

const initialState = {
  ids: []
}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload) =>
    (Array.isArray(payload.result) ? { ...state, ids: payload.result } : state)
  )
}, initialState)

export default reducer
