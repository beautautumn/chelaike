import expect from 'expect'
import reducer, { fetch, create, update, destroy } from '../roles'

describe('roles', () => {
  describe('reducer', () => {
    it('return the initial state', () => {
      expect(reducer()).toEqual({
        ids: [],
        fetching: false,
        fetched: false,
        saving: false
      })
    })

    it('handle fetch success', () => {
      const action = {
        type: fetch.success.getType(),
        payload: {
          result: [1, 2]
        }
      }
      const expectedState = {
        ids: [1, 2],
        fetching: false,
        fetched: true,
      }
      expect(reducer({}, action)).toEqual(expectedState)
    })

    ;[create, update].forEach(actionCreator => {
      it(`handle ${actionCreator.request.getType()}`, () => {
        const action = { type: actionCreator.request.getType() }

        const expectedState = {
          saving: true,
          saved: false
        }

        expect(reducer({}, action)).toEqual(expectedState)
      })
    })

    it('handle create success', () => {
      const previousState = {
        ids: []
      }

      const action = {
        type: create.success.getType(),
        payload: {
          result: 1
        }
      }

      const expectedState = {
        ids: [1],
        saving: false,
        saved: true
      }

      expect(reducer(previousState, action)).toEqual(expectedState)
    })

    it('handle update success', () => {
      const previousState = {
        ids: [1, 2],
        saved: false
      }
      const action = {
        type: update.success.getType(),
        payload: {
          result: 1
        }
      }
      const expectedState = {
        ids: [1, 2],
        saving: false,
        saved: true
      }

      expect(reducer(previousState, action)).toEqual(expectedState)
    })

    it('handle destroy success', () => {
      const previousState = {
        ids: [1, 2]
      }

      const action = {
        type: destroy.success.getType(),
        payload: {
          result: 1
        }
      }

      const expectedState = {
        destroyed: true,
        ids: [2]
      }

      expect(reducer(previousState, action)).toEqual(expectedState)
    })
  })
})
