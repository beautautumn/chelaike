import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'
import { PAGE_SIZE } from 'constants'

export const fetch = createApiAction('Statistics/FETCHMAINTENANCERECORD', query => ({
  method: 'get',
  endpoint: '/maintenance_records/statistics',
  schema: Schemas.STATISTICS_MAINTENANCE_RECORD_ARRAY,
  query,
}), (query, reset) => ({
  query,
  reset,
}))

const initialState = {
  ids: [],
  fetchParams: {
    page: 1,
    perPage: PAGE_SIZE,
  },
  total: 0,
  storedCount: 0,
  fetching: false,
  fetched: false,
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetching: true,
    fetched: false
  }))

  on(fetch.success, (state, payload, meta) => {
    const fetchParams = meta.query ? meta.query : {}

    const ids = payload.result
    const total = meta.totalCount
    const storedCount = meta.storedCount

    return {
      ...state,
      ids,
      fetchParams,
      fetching: false,
      fetched: true,
      total,
      storedCount,
    }
  })
}, initialState)

export default reducer
