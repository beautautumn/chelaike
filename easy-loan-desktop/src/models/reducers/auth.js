import { createAction, handleActions } from 'redux-actions'
import createApiAction from '../../utils/createApiAction'

export const code = createApiAction('auth/code')
export const login = createApiAction('auth/login')
export const profile = createApiAction('auth/profile')
export const logout = createAction('auth/logout')

const initialState = {
  loading: false,
  stopCountdown: false,
  error: null,
}

export default handleActions({
  [code.request](state) {
    return { ...state, stopCountdown: false, error: null, }
  },
  [code.failure](state, { payload }) {
    return { ...state, stopCountdown: true, error: payload, }
  },
  [login.request](state) {
    return { ...state, loading: true, }
  },
  [login.success](state) {
    return { ...state, loading: false, }
  },
  [login.failure](state, { payload }) {
    return { ...state, loading: false, error: payload, }
  },
  [logout](state) {
    return initialState
  },
}, initialState)
