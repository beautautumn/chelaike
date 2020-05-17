import { createApiAction, createReducer } from 'rector/redux'

export const fetchOne = createApiAction('companies/FETCH', () => ({
  method: 'get',
  endpoint: '/company',
}))

export const unify = createApiAction('companies/UNIFY', unified => ({
  method: 'put',
  endpoint: '/company/unified_management',
  body: {
    company: { settings: { unified_management: unified } }
  },
}))

export const updateStockNumber = createApiAction('companies/UPDATE_STOCK_NUMBER', stockNumber => ({
  method: 'put',
  endpoint: '/company/automated_stock_number',
  body: {
    company: { settings: { ...stockNumber } }
  },
}))

export const update = createApiAction('companies/UPDATE', company => ({
  method: 'put',
  endpoint: '/company',
  body: { company },
}))

const initialState = {
  ids: [],
  searchResult: [],
  saving: false
}

const reducer = createReducer(on => {
  on(fetchOne.success, (state, payload) => ({
    ...state,
    currentCompany: payload,
  }))

  on(update.request, state => ({
    ...state,
    saving: true,
    saved: false,
  }))

  on([update.success, unify.success, updateStockNumber.success], (state, payload) => ({
    ...state,
    saving: false,
    saved: true,
    currentCompany: {
      ...state.currentCompany,
      ...payload,
    },
  }))

  on(update.error, state => ({
    ...state,
    saving: false,
    saved: false,
  }))
}, initialState)

export default reducer
