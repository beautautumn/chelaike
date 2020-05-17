import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('intentionLevels/CREATE', intentionLevel => ({
  method: 'post',
  endpoint: '/intention_levels',
  body: { intentionLevel },
  schema: Schemas.INTENTION_LEVEL,
}))

export const fetch = createApiAction('intentionLevels/FETCH', () => ({
  method: 'get',
  endpoint: '/intention_levels',
  schema: Schemas.INTENTION_LEVEL_ARRAY,
}))

export const update = createApiAction('intentionLevels/UPDATE', intentionLevel => ({
  method: 'put',
  endpoint: `/intention_levels/${intentionLevel.id}`,
  body: { intentionLevel },
  schema: Schemas.INTENTION_LEVEL,
}))

export const destroy = createApiAction('intentionLevels/DESTROY', id => ({
  method: 'del',
  endpoint: `/intention_levels/${id}`,
  schema: Schemas.INTENTION_LEVEL,
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
