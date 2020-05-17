import { createApiAction, createReducer } from 'rector/redux'

export const getRecoveryTime = createApiAction('intentionRecoveries/GETRECOVERYTIME', () => ({
  method: 'get',
  endpoint: '/intention_expiration',
}))

export const setRecoveryTime = createApiAction('intentionRecoveries/SETRECOVERYTIME',
  intentionExpiration => ({
    method: 'put',
    endpoint: '/intention_expiration',
    body: { intentionExpiration },
  })
)

const initialState = {
  recycle: {},
  saved: false,
  saving: false,
}

const reducer = createReducer((on) => {
  on(getRecoveryTime.success, (state, payload) => ({
    ...state,
    recycle: payload
  }))

  on(setRecoveryTime.request, (state) => ({
    ...state,
    saving: true,
    saved: false,
  }))
  on(setRecoveryTime.success, (state, payload) => ({
    ...state,
    recycle: payload,
    saving: false,
    saved: true,
  }))
  on(setRecoveryTime.error, (state) => ({
    ...state,
    saving: false,
    saved: false,
  }))
}, initialState)

export default reducer
