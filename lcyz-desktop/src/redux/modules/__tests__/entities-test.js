import expect from 'expect'
import reducer from '../entities'

describe('entities reducer', () => {
  it('return the initial state', () => {
    expect(reducer()).toEqual({})
  })

  it('handle actions with response entities', () => {
    const previousState = {
      cars: {
        1: { name: 'Audi', price: 9 },
        2: { name: 'BWM', price: 10 }
      }
    }
    const action = {
      payload: {
        entities: {
          cars: {
            2: { name: 'BWM', price: 11 },
            3: { name: 'Ford' },
            4: { name: 'Ferrari' }
          }
        }
      }
    }
    const expectedState = {
      cars: {
        1: { name: 'Audi', price: 9 },
        2: { name: 'BWM', price: 11 },
        3: { name: 'Ford' },
        4: { name: 'Ferrari' },
      },
    }
    expect(reducer(previousState, action)).toEqual(expectedState)
  })
})
