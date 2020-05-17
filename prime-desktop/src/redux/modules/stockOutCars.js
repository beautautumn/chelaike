import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'
import without from 'lodash/without'
import isUndefined from 'lodash/isUndefined'
import { create as refund } from './refundInventories'
import { PAGE_SIZE } from 'constants'

export const fetch = createApiAction('stockOutCars/FETCH', query => ({
  method: 'get',
  endpoint: '/cars/out_of_stock',
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
      total,
    }
  })

  on(refund.success, (state, payload) => ({
    ...state,
    ids: without(state.ids, payload.carId)
  }))
}, initialState)

export default reducer
