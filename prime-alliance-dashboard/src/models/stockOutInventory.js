import feeble from 'feeble'

const model = feeble.model({
  namespace: 'stockOutInventory',
  state: {
    current: null,
  },
})

model.apiAction('fetch', carId => ({
  method: 'get',
  endpoint: `/cars/${carId}/stock_out_inventory`,
}))

model.reducer(on => {
  on(model.fetch.success, (state, payload) => ({
    ...state,
    current: payload,
  }))
})

export default model
