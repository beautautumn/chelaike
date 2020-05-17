import { createAction, handleActions } from 'redux-actions';

export const setTitle = createAction('layout/setTitle');

const initialState = {
  pageTitle: null,
};

export default handleActions(
  {
    [setTitle](state, { payload }) {
      console.log(payload);
      return { pageTitle: payload };
    }
  },
  initialState
);
