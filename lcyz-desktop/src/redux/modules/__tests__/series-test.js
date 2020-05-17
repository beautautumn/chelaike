import expect from 'expect'
import reducer, { fetch } from '../series'

describe('series', () => {
  describe('reducer', () => {
    it('handle fetch success', () => {
      const action = {
        type: fetch.success.getType(),
        payload: [
          {
            series: [
              { name: '奥迪A3' },
              { name: '奥迪A4' }
            ],
            manufacturerName: '一汽-大众奥迪'
          },
          {
            series: [
              { name: '奥迪RS 5' },
              { name: '奥迪RS 7' }
            ],
            manufacturerName: '奥迪RS'
          }
        ],
        meta: {
          key: 'brand1'
        }
      }
      const expectedState = {
        brand1: [
          { name: '奥迪A3' },
          { name: '奥迪A4' },
          { name: '奥迪RS 5' },
          { name: '奥迪RS 7' }
        ]
      }

      expect(reducer(undefined, action)).toEqual(expectedState)
    })
  })
})
