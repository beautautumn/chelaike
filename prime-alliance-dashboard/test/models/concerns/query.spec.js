import test from 'ava'
import feeble from 'feeble'
import query from 'models/concerns/query'

const model = feeble.model({
  namespace: 'test',
})

model.apiAction('fetch')

model.reducer(query(model.fetch))

const reducer = model.getReducer()

test('set query', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: model.fetch.request.getType(), meta: { query: { name: 'Meck' } } }
    ),
    { query: { name: 'Meck' } }
  )
})
