import { handleActions } from 'redux-actions'
import createApiAction from '../../utils/createApiAction'
import merge from 'lodash/merge'
import concat from 'lodash/concat'
import forEach from 'lodash/forEach'

export const fetch = createApiAction('series/fetch')

const initialState = {
  data: [],
  query: {},
  loading: false
}

export default handleActions({
  [fetch.request](state, { payload }) {
    const query = payload ? merge({}, state.query, payload) : initialState.query
    return { ...state, query, loading: true }
  },
  [fetch.success](state, { payload }) {
    let result = []
    forEach(payload, collection => {
      result = concat(result, collection.series)
    })
    return { ...state, data: result, loading: false }
  },
  [fetch.failure](state, { payload }) {
    return { ...state, error: payload, loading: false }
  },
}, initialState)
