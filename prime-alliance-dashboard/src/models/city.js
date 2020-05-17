import feeble from 'feeble'
import { dynamic } from './concerns'

const model = feeble.model({
  namespace: 'city',
  state: [],
})

model.apiAction('fetch', province => ({
  method: 'get',
  query: { province: { name: province } },
  endpoint: '~/api/v1/regions/cities',
}), (province, key) => ({
  key,
}))

model.reducer(on => {
  on(model.fetch.success, (state, payload) => payload)
}, dynamic)

export default model
