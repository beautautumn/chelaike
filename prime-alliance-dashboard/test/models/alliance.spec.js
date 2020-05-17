import test from 'ava'
import Alliance from 'models/alliance'

const reducer = Alliance.getReducer()

test('fetch success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Alliance.fetch.success.getType(), payload: { name: 'justice' } }
    ),
    { alliance: { name: 'justice' }, saving: false },
  )
})

test('update request', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Alliance.update.request.getType() }
    ),
    { alliance: {}, saving: true },
  )
})

test('update success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Alliance.update.success.getType(), payload: { name: 'justice' } },
    ),
    { alliance: { name: 'justice' }, saving: false },
  )
})

test('update error', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Alliance.update.error.getType() },
    ),
    { alliance: {}, saving: false },
  )
})
