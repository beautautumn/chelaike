import expect from 'expect'
import reducer, { login, logout } from '../auth'

describe('auth reducer', () => {
  it('return the initial state', () => {
    expect(reducer()).toEqual({
      logging: false,
      registering: false
    })
  })

  it('hanlde login request', () => {
    const action = {
      type: login.request.getType()
    }
    expect(reducer({}, action)).toEqual({ logging: true })
  })

  it('hanlde login success', () => {
    const action = {
      type: login.success.getType(),
      payload: {
        name: 'Meck'
      }
    }
    expect(reducer({}, action)).toEqual({
      error: null,
      logging: false,
      user: { name: 'Meck' }
    })
  })

  it('handle logout', () => {
    const state = {
      user: {
        name: 'Meck',
        token: 'thetoken'
      }
    }
    const action = { type: logout.getType() }

    expect(reducer(state, action)).toEqual({
      user: {
        name: 'Meck',
        token: null
      }
    })
  })
})
