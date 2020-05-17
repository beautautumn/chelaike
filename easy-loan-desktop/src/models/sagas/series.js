import { all, fork, take, put, call, select } from 'redux-saga/effects'
import { fetch } from '../reducers/series'
import callApi from '../services/callApi'

function* watchFetch() {
  while (true) {
    yield take(fetch.request)
    const query = yield select((state) => state.series.query)
    if (query.name) {
      const { response, error } = yield call(() => callApi('/brands/series', {
        query
      }))
      if (response) {
        yield put(fetch.success(response.data))
      } else {
        yield put(fetch.failure(error))
      }
    } else {
      yield put(fetch.success([]))
    }
  }
}

export default function* company() {
  yield all([
    fork(watchFetch)
  ])
}
