import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('shops/CREATE', shop => ({
  method: 'post',
  endpoint: '/shops',
  body: { shop },
  schema: Schemas.SHOP,
}))

export const fetch = createApiAction('shops/FETCH', () => ({
  method: 'get',
  endpoint: '/shops',
  schema: Schemas.SHOP_ARRAY,
}))

export const update = createApiAction('shops/UPDATE', shop => ({
  method: 'put',
  endpoint: `/shops/${shop.id}`,
  body: { shop },
  schema: Schemas.SHOP,
}))

export const destroy = createApiAction('shops/DESTROY', id => ({
  method: 'del',
  endpoint: `/shops/${id}`,
  schema: Schemas.SHOP,
}))

const initialState = {
  ids: [],
  fetching: false,
  fetched: false,
  saving: false
}

const reducer = createReducer({}, initialState)

const finnalReducer = composeReducers(
  reducer,
  crud({ create, fetch, update, destroy })
)

export default finnalReducer
