import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('channels/CREATE', channel => ({
  method: 'post',
  endpoint: '/channels',
  body: { channel },
  schema: Schemas.CHANNEL,
}))

export const fetch = createApiAction('channels/FETCH', () => ({
  method: 'get',
  endpoint: '/channels',
  schema: Schemas.CHANNEL_ARRAY,
}))

export const update = createApiAction('channels/UPDATE', channel => ({
  method: 'put',
  endpoint: `/channels/${channel.id}`,
  body: { channel },
  schema: Schemas.CHANNEL,
}))

export const destroy = createApiAction('channels/DESTROY', id => ({
  method: 'del',
  endpoint: `/channels/${id}`,
  schema: Schemas.CHANNEL,
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
