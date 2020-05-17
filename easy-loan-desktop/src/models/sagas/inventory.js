import { all, fork, take, put, call, select } from 'redux-saga/effects'
import { fetch } from '../reducers/inventory'
import callApi from '../services/callApi'
import { inventoryArraySchema } from '../services/schemas'

function* watchFetch() {
  while (true) {
    yield take(fetch.request)
    const query = yield select((state) => state.inventories.query)
    const { response, error } = yield call(() => callApi('/inventory/index', {
      query: { ...query, page: query.page - 1 },
      schema: inventoryArraySchema,
    }))
    if (response) {
      yield put(fetch.success({ ...response.data, total: response.meta.total }))
    } else {
      yield put(fetch.failure(error))
    }
  }
}



export default function* inventory() {
  yield all([
    fork(watchFetch),
  ])
}
