import test from 'ava'
import Auth from 'models/auth'

const reducer = Auth.getReducer()

test('login request', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Auth.login.request.getType(), payload: { name: 'Meck' } }
    ),
    { logging: true }
  )
})

test('login success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Auth.login.success.getType(), payload: { name: 'Meck' } }
    ),
    { user: { name: 'Meck' }, error: null, logging: false }
  )
})

test('login error', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Auth.login.error.getType(), payload: { message: 'wrong password' } }
    ),
    { error: 'wrong password', logging: false }
  )
})

test('fetchMe success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: Auth.fetchMe.success.getType(), payload: { name: 'Meck' } }
    ),
    { logging: false, user: { name: 'Meck' } }
  )
})
