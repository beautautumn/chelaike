import expect from 'expect'
import reducer, { fetch } from '../intentions.js'
import { PAGE_SIZE } from 'constants'

describe('intentions', () => {
  describe('reducer', () => {
    it('return the initial state', () => {
      const expectedState = {
        ids: [],
        fetchParams: {
          page: 1,
          orderBy: 'desc',
          orderField: 'id',
          perPage: PAGE_SIZE,
        },
        total: 0,
        checkedIds: [],
        saving: false
      }

      expect(reducer()).toEqual(expectedState)
    })

    it('handle fetch success', () => {
      const action = {
        type: fetch.success.getType(),
        payload: {
          result: [1, 2],
        },
        meta: {
          total: 2,
          query: {}
        }
      }

      const prevState = {
        ids: []
      }

      const expectedState = {
        ids: [1, 2],
        fetchParams: {},
        total: 2,
        end: true,
        fetching: false,
        fetched: true
      }

      expect(reducer(prevState, action)).toEqual(expectedState)
    })
  })
})
