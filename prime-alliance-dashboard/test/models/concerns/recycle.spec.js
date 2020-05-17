import test from 'ava'
import recycle from 'models/concerns/recycle'

const reducer = (state = 1, action) => {
  switch (action.type) {
    case 'FETCH_SUCCESS':
      return 2
    default:
      return state
  }
}

test('reset state when match given action', t => {
  const decorated = recycle('LOCATION_CHANGE', reducer)
  t.is(decorated(3, { type: 'LOCATION_CHANGE' }), 1)
})

test('return state when not match given action', t => {
  const decorated = recycle('LOCATION_CHANGE', reducer)
  t.is(decorated(1, { type: 'FETCH_SUCCESS' }), 2)
})
