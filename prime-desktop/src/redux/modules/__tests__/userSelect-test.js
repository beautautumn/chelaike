import expect from 'expect'

import reducer, { fetch } from '../userSelect'

describe('userSelect', () => {
  describe('reducer', () => {
    it('handle fetch request', () => {
      const action = {
        type: fetch.request.getType()
      }

      const previousState = {
        fetching: false
      }

      const expectedState = {
        fetching: true
      }

      expect(reducer(previousState, action)).toEqual(expectedState)
    })

    it('handle fetch success', () => {
      const action = {
        type: fetch.success.getType(),
        payload: {
          result: [1, 2],
        }
      }

      const previousState = {
        ids: [],
        fetching: false,
        fetched: false
      }

      const expectedState = {
        ids: [1, 2],
        fetching: false,
        fetched: true
      }

      expect(reducer(previousState, action)).toEqual(expectedState)
    })
  })
})
