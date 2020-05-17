import feeble from 'feeble'

const model = feeble.model({
  namespace: 'authority',
  state: {
    data: [],
    fetching: false,
    fetched: false,
  },
})

model.apiAction('fetch', () => ({
  method: 'get',
  endpoint: '/authorities',
}))

model.reducer(on => {
  on(model.fetch.request, state => ({
    ...state,
    fetching: true,
    fetched: false,
  }))

  on(model.fetch.success, (state, payload) => ({
    ...state,
    data: payload,
    fetching: false,
    fetched: true,
  }))
})

export default model
