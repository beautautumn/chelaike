import expect from 'expect'
import reducer, { create } from '../carPrices'

describe('carPrices reducer', () => {
  it('return the initial state', () => {
    expect(reducer()).toEqual({ saving: false })
  })

  it('handle create request', () => {
    const action = { type: create.request.getType() }
    const expectedState = { saving: true, saved: false }

    expect(reducer({}, action)).toEqual(expectedState)
  })

  it('handle CREATE_SUCCESS', () => {
    const action = { type: create.success.getType() }
    const expectedState = { saving: false, saved: true }

    expect(reducer({}, action)).toEqual(expectedState)
  })
})
