import expect from 'expect'
import reducer, { fetch } from '../styles'

describe('styles reducer', () => {
  describe('reducer', () => {
    it('handle fetch success', () => {
      const action = {
        type: fetch.success.getType(),
        payload: [
          {
            year: '2015款',
            models: [
              { id: 18658, name: '2015款 Sportback 35 TFSI 手动进取型' },
              { id: 21567, name: '2015款 Sportback 40 TFSI 自动舒适型' }
            ]
          },
          {
            year: '2014款',
            models: [
              { id: 16571, name: '2014款 Sportback 35 TFSI 自动豪华型' },
              { id: 18637, name: '2014款 Sportback 35 TFSI 自动进取型' }
            ]
          }
        ],
        meta: {
          key: 'brand1'
        }
      }
      const expectedState = {
        brand1: [
          { id: 18658, name: '2015款 Sportback 35 TFSI 手动进取型' },
          { id: 21567, name: '2015款 Sportback 40 TFSI 自动舒适型' },
          { id: 16571, name: '2014款 Sportback 35 TFSI 自动豪华型' },
          { id: 18637, name: '2014款 Sportback 35 TFSI 自动进取型' }
        ]
      }

      expect(reducer(undefined, action)).toEqual(expectedState)
    })
  })
})
