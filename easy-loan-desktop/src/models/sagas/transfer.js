import { all, fork, take, put, call, select } from 'redux-saga/effects'
import { fetch, changeStatus, setEvaluate, fetchChe300Evaluate } from '../reducers/transfer'
import callApi from '../services/callApi'
import { transferArraySchema } from '../services/schemas'

function* watchFetch() {
  while (true) {
    yield take(fetch.request)
    const query = yield select((state) => state.transfers.query)
    const { response, error } = yield call(() => callApi('/replaceCar', {
      query: { ...query, ...query.query, page: query.page - 1 },
      schema: transferArraySchema,
    }))
    if (response) {
      yield put(fetch.success({ ...response.data, total: response.meta.total }))
    } else {
      yield put(fetch.failure(error))
    }
  }
}

function* watchChangeStatus() {
  while (true) {
    const { payload } = yield take(changeStatus.request)
    const { response, error } = yield call(() => callApi(`/replaceCar/${payload.id}`, {
      body: payload,
      method: 'post'
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

export default function* transfer() {
  yield all([
    fork(watchFetch),
    fork(watchChangeStatus),
    fork(watchSetEvaluate),
    fork(watchFetchChe300Evaluate)
  ])
}
