import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('cooperationCompanies/CREATE', cooperationCompany => ({
  method: 'post',
  endpoint: '/cooperation_companies',
  body: { cooperationCompany },
  schema: Schemas.COOPERATION_COMPANY,
}))

export const fetch = createApiAction('cooperationCompanies/FETCH', () => ({
  method: 'get',
  endpoint: '/cooperation_companies',
  schema: Schemas.COOPERATION_COMPANY_ARRAY,
}))

export const update = createApiAction('cooperationCompanies/UPDATE', cooperationCompany => ({
  method: 'put',
  endpoint: `/cooperation_companies/${cooperationCompany.id}`,
  body: { cooperationCompany },
  schema: Schemas.COOPERATION_COMPANY,
}))

export const destroy = createApiAction('cooperationCompanies/DESTROY', id => ({
  method: 'del',
  endpoint: `/cooperation_companies/${id}`,
  schema: Schemas.COOPERATION_COMPANY,
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
