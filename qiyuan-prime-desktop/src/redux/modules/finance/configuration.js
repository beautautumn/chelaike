import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('financeConfiguration/FETCH', () => ({
  method: 'get',
  endpoint: '/company/financial_configuration'
}))

export const update = createApiAction('financeConfiguration/UPDATE', financialConfiguration => ({
  method: 'put',
  endpoint: '/company/financial_configuration',
  body: { company: { financialConfiguration } },
}))

const initialState = {
  saving: false,
  saved: false,
}

const reducer = createReducer((on) => {
  on(fetch.success, (state, payload) => ({
    ...state,
    data: payload
  }))

  on(update.request, (state) => ({
    ...state,
    saving: true,
    saved: false,
  }))
  on(update.success, (state, payload) => ({
    ...state,
    saving: false,
    saved: true,
    data: payload,
  }))
  on(update.error, (state) => ({
    ...state,
    saving: false,
    saved: false,
  }))
}, initialState)

export default reducer
