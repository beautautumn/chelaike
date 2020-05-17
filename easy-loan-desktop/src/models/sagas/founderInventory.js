import { all, fork, take, put, call, select } from 'redux-saga/effects';
import { fetch } from '../reducers/founderInventory';
import callApi from '../services/callApi';
import { founderInventoryArraySchema } from '../services/schemas';

function* watchFetch() {
  while (true) {
    yield take(fetch.request);
    const query = yield select(state => state.founderInventories.query);
    const { response, error } = yield call(() =>
      callApi('/inventory/funderCompany/index', {
        query: { ...query, page: query.page - 1 },
        schema: founderInventoryArraySchema
      })
    );
    if (response) {
      yield put(
        fetch.success({ ...response.data, total: response.meta.total })
      );
    } else {
      yield put(fetch.failure(error));
    }
  }
}

export default function* founderInventory() {
  yield all([fork(watchFetch)]);
}
