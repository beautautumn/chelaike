import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'
import isUndefined from 'lodash/isUndefined'
import { PAGE_SIZE } from 'constants'

export const fetch = createApiAction('prepareRecordCars/FETCH', query => ({
  method: 'get',
  endpoint: '/cars/prepare_records',
  schema: Schemas.CAR_ARRAY,
  query: { ...query, perPage: PAGE_SIZE },
}), query => ({
  query,
}))

const initialState = {
  ids: [],
  query: {},
  total: 0
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetching: true,
    fetched: false
  }))

  on(fetch.success, (state, payload, meta) => {
    const total = isUndefined(meta.total) ? state.total : meta.total

    return {
      ...state,
      ids: payload.result,
      fetching: false,
      fetched: true,
      query: meta.query,
      total
    }
  })
}, initialState)

export default reducer
