import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud, query, pagination } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('cooperationCompanies/CREATE', cooperationCompany => ({
  method: 'post',
  endpoint: '/owner_companies',
  body: { ownerCompany: cooperationCompany },
  schema: Schemas.COOPERATION_COMPANY,
}))

export const fetch = createApiAction('cooperationCompanies/FETCH', query => ({
  method: 'get',
  endpoint: '/owner_companies',
  schema: Schemas.COOPERATION_COMPANY_ARRAY,
  query,
}), query => ({
  query,
}))

export const update = createApiAction('cooperationCompanies/UPDATE', cooperationCompany => ({
  method: 'put',
  endpoint: `/owner_companies/${cooperationCompany.id}`,
  body: { ownerCompany: cooperationCompany },
  schema: Schemas.COOPERATION_COMPANY,
}))

export const destroy = createApiAction('cooperationCompanies/DESTROY', id => ({
  method: 'del',
  endpoint: `/owner_companies/${id}`,
  schema: Schemas.COOPERATION_COMPANY,
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
