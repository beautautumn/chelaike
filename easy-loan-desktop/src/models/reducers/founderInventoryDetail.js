import { createAction, handleActions } from 'redux-actions';
import createApiAction from '../../utils/createApiAction';
import merge from 'lodash/merge';

export const fetch = createApiAction('fInventoryDetail/fetch');
export const setVisible = createAction('fInventoryDetail/setVisible');

const initialState = {
  ids: [],
  loading: false,
  confirmLoading: false,
  visible: false
};

export default handleActions(
  {
    [fetch.request](state, { payload }) {
      const query = payload
        ? merge({}, state.query, payload.query, { id: payload.id })
        : merge({}, { id: payload.id });
      return { ...state, loading: true, query };
    },
    [fetch.success](state, { payload }) {
      console.log('state', state);
      return {
        ...state,
        ids: [payload.result],
        loading: false
      };
    },
    [fetch.failure](state, { payload }) {
      return { ...state, error: payload, loading: false };
    },
    [setVisible](state, { payload }) {
      return { ...state, visible: payload };
    }
  },
  initialState
);
