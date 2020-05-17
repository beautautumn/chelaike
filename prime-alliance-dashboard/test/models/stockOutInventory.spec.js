import test from 'ava'
import StockOutInventory from 'models/stockOutInventory'

const reducer = StockOutInventory.getReducer()

test('fetch success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: StockOutInventory.fetch.success.getType(), payload: { foo: 'bar' } }
    ),
    { current: { foo: 'bar' } }
  )
})
