import expect from 'expect'
import reducer, { fetch } from '../enumValues'

describe('enumValues reducer', () => {
  it('return the initial state', () => {
    expect(reducer()).toEqual({ fetched: false })
  })

  it('handle fetch success', () => {
    const action = {
      type: fetch.success.getType(),
      payload: {
        car: {
          state: {
            in_hall: '在厅',
            preparing: '整备',
          },
        },
        user: {
          state: {
            enabled: '已启用',
            disabled: '已禁用'
          }
        }
      }
    }
    const expectedState = {
      car: {
        state: {
          in_hall: '在厅',
          preparing: '整备',
        },
      },
      user: {
        state: {
          enabled: '已启用',
          disabled: '已禁用'
        }
      },
      fetched: true
    }

    expect(reducer(undefined, action)).toEqual(expectedState)
  })
})
