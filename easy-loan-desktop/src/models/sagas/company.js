import { all, fork, take, put, call, select } from 'redux-saga/effects'
import { fetch, create, update } from '../reducers/company'
import callApi from '../services/callApi'
import { companyArraySchema } from '../services/schemas'

function* watchFetch() {
  while (true) {
    yield take(fetch.request)
    const query = yield select((state) => state.companies.query)
    const { response, error } = yield call(() => callApi('/debtor/index', {
      query: { ...query, page: query.page - 1 },
      schema: companyArraySchema,
    }))
    if (response) {
      yield put(fetch.success({ ...response.data, total: response.meta.total }))
    } else {
      yield put(fetch.failure(error))
    }
  }
}

function* watchCreate() {
  while (true) {
    const { payload } = yield take(create.request)
    const { response, error } = yield call(() => callApi(`/debtor/create`, {
      body: { json: payload },
      method: 'post'
    }))
    if (response) {
      yield put(create.success(response))
      yield put(fetch.request())
    } else {
      yield put(create.failure(error))
    }
  }
}

function* watchUpdate() {
  while (true) {
    const { payload } = yield take(update.request)
    const { response, error } = yield call(() => callApi(`/debtor/update/${payload.id}`, {
      body: { json: payload },
      method: 'post'
    }))
    if (response) {
      yield put(update.success(response))
      const query = yield select((state) => state.companies.query)
      yield put(fetch.request(query))
    } else {
      yield put(update.failure(error))
    }
  }
}

export default function* company() {
  yield all([
    fork(watchFetch),
    fork(watchCreate),
    fork(watchUpdate),
  ])
}
