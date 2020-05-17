import feeble from 'feeble'
import { dynamic } from './concerns'

const model = feeble.model({
  namespace: 'style',
  state: [],
})

model.apiAction('fetch', series => ({
  method: 'get',
  endpoint: '~/api/v1/styles',
  query: { series: { name: series } },
}), (series, key) => ({
  key,
}))

model.apiAction('fetchDetail', (series, style) => ({
  method: 'get',
  endpoint: '/style',
  query: {
    series: { name: series },
    style: { name: style },
  },
}))

model.reducer(on => {
  on(model.fetch.success, (state, payload) => (
    payload.reduce((acc, style) => (
      acc.concat(style.models)
    ), [])
  ))
}, dynamic)

export default model
