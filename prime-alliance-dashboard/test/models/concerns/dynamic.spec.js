import test from 'ava'
import sinon from 'sinon'
import dynamic from 'models/concerns/dynamic'

const reducer = sinon.stub().returns(2)
const wrappedReducer = dynamic(reducer)

test('no key', t => {
  const state = 1
  const action = { type: 'ADD' }
  const nextState = wrappedReducer(state, action)

  t.is(nextState, 2)
})

test('has key', t => {
  const state = { key1: 1 }
  const action = { type: 'ADD', meta: { key: 'key1' } }
  const nextState = wrappedReducer(state, action)

  t.deepEqual(nextState, { key1: 2 })
})
