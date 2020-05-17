import { createAction, handleActions } from 'redux-actions';
import createApiAction from '../../utils/createApiAction';

export const fetch = createApiAction('profile/fetch');
export const reset = createAction('profile/reset');
export const loadAll = createAction('profile/loaded');

const initialState = {
  user: null,
  enums: null,
  loaded: false,
  debtorId: null
};

export default handleActions(
  {
    [fetch.request](state, { payload }) {
      return { ...state, user: payload };
    },
    [fetch.success](state, { payload }) {
      return { ...state, ...payload };
    },
    [fetch.failure](state, { payload }) {
      return { ...state, error: payload, loaded: false };
    },
    [loadAll](state, { payload }) {
      return { ...state, loaded: payload };
    },
    [reset](state) {
      return initialState;
    }
  },
  initialState
);
