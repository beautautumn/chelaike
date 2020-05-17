import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud, pagination, query } from '../concerns'
import Schemas from '../../schemas'

export const fetch = createApiAction('finance/shopFee/FETCH', query => ({
  method: 'get',
  endpoint: '/finance/shop_fees',
  schema: Schemas.SHOP_FEE_ARRAY,
  query: { ...query },
}), query => ({
  query
}))

export const update = createApiAction('finance/shopFee/UPDATE', shopFee => ({
  method: 'put',
  endpoint: `/finance/shop_fees/${shopFee.id}`,
  schema: Schemas.SHOP_FEE,
  body: { financeShopFee: shopFee }
}))

const initialState = {
  ids: [],
  query: {
    query: {}
  },
  total: 0,
  fetching: false,
  fetched: false,
  saving: false,
  saved: false,
}

const reducer = createReducer({}, initialState)

const finnalReducer = composeReducers(
  reducer,
  crud({ fetch, update }),
  pagination(fetch),
  query(fetch),
)

export default finnalReducer
