import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud, query, pagination } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('users/CREATE', user => ({
  method: 'post',
  endpoint: '/users',
  body: { user },
  schema: Schemas.USER,
}))

export const fetch = createApiAction('users/FETCH', query => ({
  method: 'get',
  endpoint: '/users',
  query,
  schema: Schemas.USER_ARRAY,
}), query => ({
  query,
}))

export const fetchOne = createApiAction('users/FETCH_ONE', id => ({
  method: 'get',
  endpoint: `/users/${id}`,
  schema: Schemas.USER,
}))

export const update = createApiAction('users/UPDATE', user => ({
  method: 'put',
  endpoint: `/users/${user.id}`,
  body: { user },
  schema: Schemas.USER,
}))

export const destroy = createApiAction('users/DESTROY', id => ({
  method: 'del',
  endpoint: `/users/${id}`,
  schema: Schemas.USER,
}))

const initialState = {
  ids: [],
  query: {},
  total: 0,
  fetching: false,
  fetched: false,
  saving: false,
}

const reducer = createReducer({}, initialState)

const finnalReducer = composeReducers(
  reducer,
  crud({ create, fetch, update, destroy }),
  query(fetch),
  pagination(fetch)
)

export default finnalReducer
