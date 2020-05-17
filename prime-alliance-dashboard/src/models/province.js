import feeble from 'feeble'

const model = feeble.model({
  namespace: 'province',
  state: {
    data: [],
    fetching: false,
    fetched: false,
  },
})

model.apiAction('fetch', () => ({
  method: 'get',
  endpoint: '~/api/v1/regions/provinces',
}))

model.reducer(on => {
  on(model.fetch.request, state => ({
    ...state,
    fetching: true,
  }))

  on(model.fetch.success, (state, payload) => ({
    ...state,
    data: payload,
    fetching: false,
    fetched: true,
  }))
})

export default model
