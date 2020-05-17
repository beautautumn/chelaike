import { createAction, handleActions } from 'redux-actions';
import createApiAction from '../../utils/createApiAction';
import merge from 'lodash/merge';
import { PAGE_SIZE } from '../../utils/constants';

export const fetch = createApiAction('loan/fetch');
export const changeStatus = createApiAction('loan/changeStatus');
export const fetchHistory = createApiAction('loan/fetchHistory');
export const setVisible = createAction('loan/setVisible');
export const setHistoryVisible = createAction('loan/setHistoryVisible');
export const setEvaluateVisible = createAction('loan/setEvaluateVisible');
export const setEvaluate = createApiAction('loan/setEvaluate');
export const fetchChe300Evaluate = createApiAction('loan/fetchChe300Evaluate');
export const setOperationHistoryVisible = createAction(
  'loan/setOperationHistoryVisible'
);

const initialState = {
  ids: [],
  query: { page: 1, size: PAGE_SIZE, brandName: '', type: 'pc' },
  total: 0,
  loading: false,
  confirmLoading: false,
  visible: false,
  historyVisible: false,
  evaluateVisible: false,
  car: {},
  operationHistoryVisible: false,
  loanHistoryList: []
};

export default handleActions(
  {
    [fetch.request](state, { payload }) {
      const query = payload
        ? merge({}, state.query, payload.query, {
            page: payload.page,
            size: payload.size
          })
        : initialState.query;
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
    [fetchHistory.request](state) {
      return { ...state, confirmLoading: true };
    },
    [fetchHistory.success](state, { payload }) {
      return { ...state, transferHistory: payload, historyVisible: true };
    },
    [fetchHistory.failure](state, { payload }) {
      return { ...state, confirmLoading: false, error: payload };
    },
    [changeStatus.request](state) {
      return { ...state, confirmLoading: true };
    },
    [changeStatus.success](state) {
      return { ...state, confirmLoading: false, visible: false };
    },
    [changeStatus.failure](state, { payload }) {
      return { ...state, confirmLoading: false, error: payload };
    },
    [setEvaluate.request](state) {
      return { ...state, confirmLoading: true };
    },
    [setEvaluate.success](state) {
      return { ...state, confirmLoading: false, evaluateVisible: false };
    },
    [setEvaluate.failure](state, { payload }) {
      return { ...state, confirmLoading: false, error: payload };
    },
    [fetchChe300Evaluate.request](state) {
      return { ...state };
    },
    [fetchChe300Evaluate.success](state, { payload }) {
      const car = merge({}, state.car, { estimatePriceWan: payload });
      return { ...state, car };
    },
    [fetchChe300Evaluate.failure](state, { payload }) {
      return { ...state, error: payload };
    },
    [setVisible](state, { payload }) {
      return { ...state, visible: payload };
    },
    [setHistoryVisible](state, { payload }) {
      return { ...state, historyVisible: payload };
    },
    [setOperationHistoryVisible](state, { payload }) {
      return {
        ...state,
        operationHistoryVisible: payload.operationHistoryVisible,
        loanHistoryList: payload.loanHistoryList
      };
    },
    [setEvaluateVisible](state, { payload }) {
      return {
        ...state,
        evaluateVisible: payload.evaluateVisible,
        car: payload.car
      };
    }
  },
  initialState
);
