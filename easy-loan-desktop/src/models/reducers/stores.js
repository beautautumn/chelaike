import { createAction, handleActions, combineActions } from 'redux-actions';
import createApiAction from '../../utils/createApiAction';
import merge from 'lodash/merge';
import { PAGE_SIZE } from '../../utils/constants';

export const fetch = createApiAction('stores/fetch');
export const create = createApiAction('stores/create');
export const update = createApiAction('stores/update');
export const destory = createApiAction('stores/delete');
export const setVisible = createAction('stores/setVisible');
const initialState = {
  ids: [],
  total: 0,
  query: { page: 1, size: PAGE_SIZE },
  loading: false,
  confirmLoading: false,
  visible: false
};

export default handleActions(
  {
    [fetch.request](state, { payload }) {
      const query = payload
        ? merge({}, state.query, payload.query, {
            debtorId: payload.debtorId,
            page: payload.page,
            size: payload.size
          })
        : merge({}, initialState.query, { debtorId: payload.debtorId });
      return { ...state, loading: true, query };
    },
    [fetch.success](state, { payload }) {
      return {
        ...state,
        ids: payload.result,
        total: payload.total,
        loading: false
      };
    },
    [fetch.failure](state, { payload }) {
      return { ...state, error: payload, loading: false };
    },
    [combineActions(create.request, update.request)](state) {
      return { ...state, confirmLoading: true };
    },
    [combineActions(create.success, update.success)](state) {
      return { ...state, confirmLoading: false, visible: false };
    },
    [combineActions(create.failure, update.failure)](state, { payload }) {
      return { ...state, confirmLoading: false, error: payload };
    },
    [combineActions(create.request, destory.request)](state) {
      return { ...state, confirmLoading: true };
    },
    [combineActions(create.success, destory.success)](state) {
      return { ...state, confirmLoading: false, visible: false };
    },
    [combineActions(create.failure, destory.failure)](state, { payload }) {
      return { ...state, confirmLoading: false, error: payload };
    },
    [setVisible](state, { payload }) {
      return { ...state, visible: payload };
    }
  },
  initialState
);
