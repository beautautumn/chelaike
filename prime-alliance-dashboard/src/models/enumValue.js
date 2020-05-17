import feeble from 'feeble'
import omit from 'lodash/omit'
import pick from 'lodash/pick'

const model = feeble.model({
  namespace: 'enumValue',
  state: {},
})

model.apiAction('fetch', () => ({
  method: 'get',
  endpoint: '~/api/enumerize_locales',
  raw: true,
}))

model.reducer(on => {
  on(model.fetch.success, (state, payload) => (
    payload
  ))
})

const stockOutCarStates = ['driven_back', 'sold', 'acquisition_refunded']

model.selector('carStates',
  () => model.getState().car.state,
  carStates => ({
    inStockCarStates: omit(carStates, ...stockOutCarStates),
    stockOutCarStates: pick(carStates, ...stockOutCarStates),
  })
)

export default model
