import { createAction, handleActions, combineActions } from 'redux-actions'
import createApiAction from '../../utils/createApiAction'

export const fetch = createApiAction('role/fetch')
export const create = createApiAction('role/create')
export const update = createApiAction('role/update')
export const destory = createApiAction('role/delete')
export const setVisible = createAction('role/setVisible')

const initialState = {
  ids: [],
  query: {},
  loading: false,
  confirmLoading: false,
  visible: false,
}

export default handleActions({
  [fetch.request](state, { payload }) {
    return { ...state, loading: true }
  },
  [fetch.success](state, { payload }) {
    return { ...state, ids: payload.result, loading: false }
  },
  [fetch.failure](state, { payload }) {
    return { ...state, error: payload, loading: false }
  },
  [combineActions(create.request, update.request)](state) {
    return { ...state, confirmLoading: true }
  },
  [combineActions(create.success, update.success)](state) {
    return { ...state, confirmLoading: false, visible: false }
  },
  [combineActions(create.failure, update.failure)](state, { payload }) {
    return { ...state, confirmLoading: false, error: payload }
  },
  [setVisible](state, { payload }) {
    return { ...state, visible: payload }
  },
}, initialState)
