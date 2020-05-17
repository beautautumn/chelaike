import feeble from 'feeble'

const model = feeble.model({
  namespace: 'maintenanceRecord',
  state: {
    current: null,
  },
})

model.apiAction('fetch', carId => ({
  method: 'get',
  endpoint: '/maintenance_records/detail',
  query: { carId },
}))

model.reducer(on => {
  on(model.fetch.success, (state, payload) => ({
    ...state,
    current: payload,
  }))
})

export default model
