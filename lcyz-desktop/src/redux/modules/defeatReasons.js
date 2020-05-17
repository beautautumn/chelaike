import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('defeatReasons/CREATE', failReason => ({
  method: 'post',
  endpoint: '/intention_push_fail_reasons',
  body: { failReason },
  schema: Schemas.DEFEAT_REASON,
}))

export const fetch = createApiAction('defeatReasons/FETCH', () => ({
  method: 'get',
  endpoint: '/intention_push_fail_reasons',
  schema: Schemas.DEFEAT_REASON_ARRAY,
}))

export const update = createApiAction('defeatReasons/UPDATE', failReason => ({
  method: 'put',
  endpoint: `/intention_push_fail_reasons/${failReason.id}`,
  body: { failReason },
  schema: Schemas.DEFEAT_REASON,
}))

export const destroy = createApiAction('defeatReasons/DESTROY', id => ({
  method: 'del',
  endpoint: `/intention_push_fail_reasons/${id}`,
  schema: Schemas.DEFEAT_REASON,
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
