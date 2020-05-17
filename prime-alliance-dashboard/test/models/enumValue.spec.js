import test from 'ava'
import EnumValue from 'models/enumValue'

const reducer = EnumValue.getReducer()

test('fetch success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: EnumValue.fetch.success.getType(), payload: { foo: 'bar' } }
    ),
    { foo: 'bar' }
  )
})
