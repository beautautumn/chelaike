import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('mortgageCompanies/CREATE', mortgageCompany => ({
  method: 'post',
  endpoint: '/mortgage_companies',
  body: { mortgageCompany },
  schema: Schemas.MORTGAGE_COMPANY,
}))

export const fetch = createApiAction('mortgageCompanies/FETCH', () => ({
  method: 'get',
  endpoint: '/mortgage_companies',
  schema: Schemas.MORTGAGE_COMPANY_ARRAY,
}))

export const update = createApiAction('mortgageCompanies/UPDATE', mortgageCompany => ({
  method: 'put',
  endpoint: `/mortgage_companies/${mortgageCompany.id}`,
  body: { mortgageCompany },
  schema: Schemas.MORTGAGE_COMPANY,
}))

export const destroy = createApiAction('mortgageCompanies/DESTROY', id => ({
  method: 'del',
  endpoint: `/mortgage_companies/${id}`,
  schema: Schemas.MORTGAGE_COMPANY,
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
