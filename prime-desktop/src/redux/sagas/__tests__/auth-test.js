import expect from 'expect'
import { call, put, select } from 'redux-saga/effects'
import { delay } from 'redux-saga'
import { push } from 'react-router-redux'
import { getRouting, processLogin, processLogout, saveUserToGlobal } from '../auth'
import { saveToken, removeToken } from 'redux/modules/auth'
import { replaceState } from 'redux/modules/makeHydratable'

describe('auth saga', () => {
  describe('login', () => {
    const gen = processLogin({ token: 'mytoken' }, true)

    it('set token to localStorage', () => {
      const next = gen.next()
      expect(next.value).toEqual(call(saveToken, 'mytoken', true))
    })

    it('redirect user to "/cars"', () => {
      const next = gen.next()
      expect(next.value).toEqual(put(push('/cars')))
    })
  })

  describe('logout', () => {
    global.PrimeDesktop = { initialState: { hello: 'world' } }

    const gen = processLogout()

    it('redirect user to /login', () => {
      const next = gen.next()
      expect(next.value).toEqual(put(push('/login')))
    })

    it('wait all page loaded', () => {
      const next = gen.next()
      expect(next.value).toEqual(delay(0))
    })

    it('remove token from localStorage', () => {
      const next = gen.next()
      expect(next.value).toEqual(call(removeToken))
    })

    it('clear global user info', () => {
      const next = gen.next()
      expect(next.value).toEqual(call(saveUserToGlobal, null))
    })

    it('select routing state', () => {
      const next = gen.next()
      expect(next.value).toEqual(select(getRouting))
    })

    it('reset global state', () => {
      const next = gen.next({ path: '/' })
      expect(next.value).toEqual(put(replaceState({ hello: 'world', routing: { path: '/' } })))
    })
  })
})
