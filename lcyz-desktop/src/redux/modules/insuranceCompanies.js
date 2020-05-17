import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const create = createApiAction('insuranceCompanies/CREATE', insuranceCompany => ({
  method: 'post',
  endpoint: '/insurance_companies',
  body: { insuranceCompany },
  schema: Schemas.INSURANCE_COMPANY,
}))

export const fetch = createApiAction('insuranceCompanies/FETCH', () => ({
  method: 'get',
  endpoint: '/insurance_companies',
  schema: Schemas.INSURANCE_COMPANY_ARRAY,
}))

export const update = createApiAction('insuranceCompanies/UPDATE', insuranceCompany => ({
  method: 'put',
  endpoint: `/insurance_companies/${insuranceCompany.id}`,
  body: { insuranceCompany },
  schema: Schemas.INSURANCE_COMPANY,
}))

export const destroy = createApiAction('insuranceCompanies/DESTROY', id => ({
  method: 'del',
  endpoint: `/insurance_companies/${id}`,
  schema: Schemas.INSURANCE_COMPANY,
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
