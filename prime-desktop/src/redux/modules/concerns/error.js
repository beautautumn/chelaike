import { createReducer } from 'rector/redux'
import mapValues from 'lodash/mapValues'
import merge from 'lodash/fp/merge'

export default function error(key, actionCreators) {
  return createReducer(on => {
    actionCreators.forEach(actionCreator => {
      on(actionCreator.error, (state, payload) => {
        if (payload.errors) {
          return merge(state, {
            ...mapValues(payload.errors[key], errors => ({
              submitError: errors[0]
            })),
            _error: payload.errors[key],
            _submitting: false
          })
        }
        return state
      })
    })
  })
}
