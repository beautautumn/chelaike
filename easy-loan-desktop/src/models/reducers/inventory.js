import { createAction, handleActions } from 'redux-actions'
import createApiAction from '../../utils/createApiAction'
import merge from 'lodash/merge'
import { PAGE_SIZE } from '../../utils/constants'

export const fetch = createApiAction('inventory/fetch')
export const setVisible = createAction('inventory/setVisible')

const initialState = {
  ids: [],
  total: 0,
  query: { page: 1, size: PAGE_SIZE },
  loading: false,
  confirmLoading: false,
  visible: false,
}

export default handleActions({
  [fetch.request](state, { payload }) {
    const query = payload ? merge({}, state.query, payload.query, {page: payload.page, size: payload.size}) : initialState.query
    return { ...state, loading: true, query }
  },
  [fetch.success](state, { payload }) {
    return { ...state, ids: payload.result, total: payload.total, loading: false }
  },
  [fetch.failure](state, { payload }) {
    return { ...state, error: payload, loading: false }
  },
  [setVisible](state, { payload }) {
    return { ...state, visible: payload }
  },
}, initialState)
