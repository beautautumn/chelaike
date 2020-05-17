import { createApiAction, createReducer } from 'rector/redux'

export const create = createApiAction('stockOutInventories/CREATE', (carId, stockOutInventory) => ({
  method: 'post',
  endpoint: `/cars/${carId}/stock_out_inventory`,
  body: { stockOutInventory },
}))

export const update = createApiAction('stockOutInventories/UPDATE', (carId, stockOutInventory) => ({
  method: 'put',
  endpoint: `/cars/${carId}/stock_out_inventory`,
  body: { stockOutInventory },
}))

export const fetch = createApiAction('stockOutInventories/FETCH', carId => ({
  method: 'get',
  endpoint: `/cars/${carId}/stock_out_inventory`,
}))

const initialState = {
  saving: false
}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload) => ({
    ...state,
    currentStockOutInventory: payload,
  }))

  const saveRequest = state => ({
    ...state,
    error: null,
    saving: true,
    saved: false
  })
  on(create.request, saveRequest)
  on(update.request, saveRequest)

  const saveSuccess = state => ({
    ...state,
    saving: false,
    saved: true
  })
  on(create.success, saveSuccess)
  on(update.success, saveSuccess)

  const saveError = (state, payload) => ({
    ...state,
    saving: false,
    saved: false,
    error: payload.message,
  })
  on(create.error, saveError)
  on(update.error, saveError)
}, initialState)

export default reducer
