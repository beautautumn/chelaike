import test from 'ava'
import feeble from 'feeble'
import pagination from 'models/concerns/pagination'

const model = feeble.model({
  namespace: 'test',
})

model.apiAction('fetch')

model.reducer(pagination(model.fetch))

const reducer = model.getReducer()

test('no total', t => {
  t.deepEqual(
    reducer(
      { total: 1 },
      { type: model.fetch.success.getType(), meta: {} }
    ),
    { total: 1 }
  )
})

test('has total', t => {
  t.deepEqual(
    reducer(
      { total: 1 },
      { type: model.fetch.success.getType(), meta: { total: 2 } }
    ),
    { total: 2 }
  )
})
