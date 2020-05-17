import expect from 'expect'
import reducer, { fetch } from '../brands'

describe('brands', () => {
  describe('reducer', () => {
    it('handle fetch success', () => {
      const action = {
        type: fetch.success.getType(),
        payload: [
          { firstLetter: 'A', name: '奥迪' },
          { firstLetter: 'B', name: '奔驰' }
        ]
      }

      const expectedState = {
        data: [
          { firstLetter: 'A', name: '奥迪' },
          { firstLetter: 'B', name: '奔驰' }
        ],
        fetching: false,
        fetched: true
      }

      expect(reducer(undefined, action)).toEqual(expectedState)
    })
  })
})
