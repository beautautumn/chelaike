import test from 'ava'
import Authority from 'models/authority'

const reducer = Authority.getReducer()

test('fetch request', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Authority.fetch.request.getType() }
    ),
    { data: [], fetching: true, fetched: false }
  )
})

test('fetch success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Authority.fetch.success.getType(), payload: ['在库车辆查看'] }
    ),
    { data: ['在库车辆查看'], fetching: false, fetched: true }
  )
})
