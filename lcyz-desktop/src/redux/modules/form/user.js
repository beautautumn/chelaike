import { createAction, createReducer, composeReducers } from 'rector/redux'
import { error } from '../concerns'
import { create, update } from '../users'
import merge from 'lodash/fp/merge'

export const setAuthorities = createAction('form/user/SET_AUTHORITIES', authorities => authorities)

const reducer = createReducer(on => {
  on(setAuthorities, (state, payload) =>
    merge(state, {
      authorities: {
        value: payload,
      }
    })
  )
})

const finnalReducer = composeReducers(
  reducer,
  error('user', [create, update])
)

export default finnalReducer
