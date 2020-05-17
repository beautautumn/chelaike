import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud } from './concerns'
import Schemas from '../schemas'

export const fetch = createApiAction('guestReminders/FETCH', () => ({
  method: 'get',
  endpoint: '/expiration_settings',
  schema: Schemas.EXPIRATION_SETTING_ARRAY,
}))

export const update = createApiAction('guestReminders/UPDATE', expirationSetting => ({
  method: 'put',
  endpoint: `/expiration_settings/${expirationSetting.id}`,
  body: { expirationSetting },
  schema: Schemas.EXPIRATION_SETTING,
}))

export const create = createApiAction('guestReminders/CREATE', () => ({}))
export const destroy = createApiAction('guestReminders/DESTROY', () => ({}))

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
