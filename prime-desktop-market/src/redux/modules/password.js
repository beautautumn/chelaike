import { createAction, createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'

export const change = createApiAction('password/CHANGE', user => ({
  method: 'put',
  endpoint: '/password',
  body: { user },
  schema: Schemas.PASSWORD,
}))

export const reset = createApiAction('password/RESET', data => ({
  method: 'put',
  endpoint: '/password',
  query: {
    user: { ...data, pass_reset_token: data.code }
  },
  schema: Schemas.PASSWORD,
}))

export const sendCode = createApiAction('password/EDIT', phone => ({
  method: 'get',
  endpoint: '/password/edit',
  query: {
    user: { phone }
  },
  schema: Schemas.PASSWORD,
}))

export const setCode = createAction('SET_SUCCESS', (code, phone) => ({
  code,
  phone,
}))


const initialState = {}

const reducer = createReducer(on => {
  on(change.request, state => ({
    ...state,
    changed: false,
    changing: true
  }))

  on(change.success, state => ({
    ...state,
    changed: true,
    changing: false
  }))

  on(change.error, state => ({
    ...state,
    changed: false,
    changing: false
  }))

  on(reset.request, state => ({
    ...state,
    reset: false,
  }))

  on(reset.success, state => ({
    ...state,
    reset: true,
  }))

  on(reset.error, state => ({
    ...state,
    reset: false,
  }))

  on(sendCode.request, state => ({
    ...state,
    send: false,
  }))

  on(sendCode.success, state => ({
    ...state,
    send: true,
  }))

  on(sendCode.error, state => ({
    ...state,
    send: false,
  }))

  on(setCode, (state, payload) => ({
    ...state,
    ...payload,
  }))
}, initialState)

export default reducer
