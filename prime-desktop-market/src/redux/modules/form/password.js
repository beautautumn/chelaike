import { createReducer } from 'rector/redux'
import { reset } from '../password'
import merge from 'lodash/fp/merge'

const reducer = createReducer(on => {
  on(reset.error, (state, payload) => merge(state, {
    code: {
      submitError: payload.message,
    },
    _error: {},
    _submitting: false
  })
  )
})

export default reducer
