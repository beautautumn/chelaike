import { all, fork, take, put, call, select } from 'redux-saga/effects'
import { fetch, changeStatus, fetchHistory, setEvaluate, fetchChe300Evaluate } from '../reducers/loan'
import callApi from '../services/callApi'
import { loanArraySchema } from '../services/schemas'

function* watchFetch() {
  while (true) {
    yield take(fetch.request)
    const query = yield select((state) => state.loans.query)
    const { response, error } = yield call(() => callApi('/loan_bill', {
      query: { ...query, page: query.page - 1 },
      schema: loanArraySchema,
    }))
    if (response) {
      yield put(fetch.success({ ...response.data, total: response.meta.total }))
    } else {
      yield put(fetch.failure(error))
    }
  }
}

function* watchFetchHistory() {
  while (true) {
    const { payload } = yield take(fetchHistory.request)
    const { response, error } = yield call(() => callApi(`/replaceCar/history/${payload.id}`))
    if (response) {
      yield put(fetchHistory.success(response.data))
    } else {
      yield put(fetchHistory.failure(error))
    }
  }
}

function* watchChangeStatus() {
  while (true) {
    const { payload } = yield take(changeStatus.request)
    const { response, error } = yield call(() => callApi(`/loan_bill/${payload.id}`, {
      body: payload,
      method: 'put'
    }))
    if (response) {
      yield put(changeStatus.success(response.data))
      yield put(fetch.request())
    } else {
      yield put(changeStatus.failure(error))
    }
  }
}

function* watchSetEvaluate() {
  while (true) {
    const { payload } = yield take(setEvaluate.request)
    const { response, error } = yield call(() => callApi(`/car/${payload.id}`, {
      body: payload,
      method: 'put'
    }))
    if (response) {
      yield put(setEvaluate.success(response.data))
      yield put(fetch.request())
    } else {
      yield put(setEvaluate.failure(error))
    }
  }
}

function* watchFetchChe300Evaluate() {
  while (true) {
    const { payload } = yield take(fetchChe300Evaluate.request)
    const { response, error } = yield call(() => callApi(`/Che300/${payload.id}`, {
      method: 'get'
    }))
    if (response) {
      yield put(fetchChe300Evaluate.success(response.data))
    } else {
      yield put(fetchChe300Evaluate.failure(error))
    }
  }
}

export default function* loan() {
  yield all([
    fork(watchFetch),
    fork(watchChangeStatus),
    fork(watchFetchHistory),
    fork(watchSetEvaluate),
    fork(watchFetchChe300Evaluate)
  ])
}
