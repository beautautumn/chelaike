import expect from 'expect'
import reducer, { create } from '../intentionPushHistories.js'

describe('intentionPushHitories', () => {
  describe('reducer', () => {
    it('return the initial state', () => {
      expect(reducer()).toEqual({ ids: [] })
    })

    it('handle create request', () => {
      const action = {
        type: create.request.getType()
      }

      const expectedState = {
        saved: false
      }

      expect(reducer({}, action)).toEqual(expectedState)
    })

    it('handle create success', () => {
      const action = {
        type: create.success.getType()
      }

      const expectedState = {
        saved: true
      }

      expect(reducer({}, action)).toEqual(expectedState)
    })
  })
})
