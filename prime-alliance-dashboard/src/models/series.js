import feeble from 'feeble'
import { dynamic } from './concerns'

const model = feeble.model({
  namespace: 'series',
  state: [],
})

model.apiAction('fetch', query => ({
  method: 'get',
  endpoint: '~/api/v1/series',
  query,
}), (query, key) => ({
  key,
}))

model.reducer(on => {
  on(model.fetch.success, (state, payload) => (
    payload.reduce((acc, group) => (
      acc.concat(group.series)
    ), [])
  ))
}, dynamic)

export default model
