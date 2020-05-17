import { all, fork, take, put, call } from 'redux-saga/effects'
import { fetch, create, update } from '../reducers/role'
import callApi from '../services/callApi'
import { roleArraySchema } from '../services/schemas'

function* watchFetch() {
  while (true) {
    yield take(fetch.request)
    const { response, error } = yield call(() => callApi('/authority_roles', {
      schema: roleArraySchema,
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
    const { response, error } = yield call(() => callApi(`/authority_roles`, {
      body: payload,
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
    const { response, error } = yield call(() => callApi(`/authority_roles/${payload.id}`, {
      body: payload,
      method: 'put'
    }))
    if (response) {
      yield put(update.success(response))
      yield put(fetch.request())
    } else {
      yield put(update.failure(error))
    }
  }
}

export default function* user() {
  yield all([
    fork(watchFetch),
    fork(watchCreate),
    fork(watchUpdate),
  ])
}
