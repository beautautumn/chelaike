import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('location/FETCH', () => ({
  method: 'get',
  endpoint: '~/api/util/ip_information',
}))

const initialState = {}

export default createReducer((on) => {
  on(fetch.success, (state, payload) => ({
    province: payload.region,
    city: payload.city
  }))
}, initialState)
