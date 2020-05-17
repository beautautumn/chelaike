import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('warranties/CREATE', warranty => ({
  method: 'post',
  endpoint: '/warranties',
  body: { warranty },
  schema: Schemas.WARRANTY,
}))

export const fetch = createApiAction('warranties/FETCH', () => ({
  method: 'get',
  endpoint: '/warranties',
  schema: Schemas.WARRANTY_ARRAY,
}))

export const update = createApiAction('warranties/UPDATE', warranty => ({
  method: 'put',
  endpoint: `/warranties/${warranty.id}`,
  body: { warranty },
  schema: Schemas.WARRANTY,
}))

export const destroy = createApiAction('warranties/DESTROY', id => ({
  method: 'del',
  endpoint: `/warranties/${id}`,
  schema: Schemas.WARRANTY,
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
