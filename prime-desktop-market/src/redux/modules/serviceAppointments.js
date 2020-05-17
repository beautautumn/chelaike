import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'
import isUndefined from 'lodash/isUndefined'
import { PAGE_SIZE } from 'constants'
import merge from 'lodash/fp/merge'

export const fetch = createApiAction('serviceAppointments/FETCH', query => ({
  method: 'get',
  endpoint: '/service_appointments',
  schema: Schemas.CAR_APPOINTMENT_ARRAY,
  query,
}), (query, reset) => ({
  query,
  reset,
}))

const initialState = {
  ids: [],
  fetchParams: {
    page: 1,
    orderBy: 'desc',
    orderField: 'id'
  },
  total: 0
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetching: true,
    fetched: false
  }))

  on(fetch.success, (state, payload, meta) => {
    const fetchParams = meta.query ? meta.query : {}

    let ids = state.ids
    if (meta.reset) {
      ids = payload.result
    } else {
      if (Array.isArray(payload.result)) {
        ids = [...ids, ...payload.result]
      }
    }

    const end = payload.result.length < PAGE_SIZE
    const total = isUndefined(meta.total) ? state.total : meta.total

    return merge(state, {
      ids,
      fetchParams,
      fetching: false,
      fetched: true,
      end,
      total
    })
  })
}, initialState)

export default reducer
