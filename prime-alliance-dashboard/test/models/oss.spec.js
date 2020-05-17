import test from 'ava'
import sinon from 'sinon'
import Oss from 'models/oss'

const reducer = Oss.getReducer()

test('fetch request', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Oss.fetch.request.getType() }
    ),
    { fetched: false }
  )
})

test('fetch success', t => {
  sinon.stub(Date, 'now').returns(1466269380000)

  t.deepEqual(
    reducer(
      undefined,
      { type: Oss.fetch.success.getType(), payload: { foo: 'bar' } }
    ),
    { foo: 'bar', fetched: true, expiredAt: 1466269452000 }
  )
})
