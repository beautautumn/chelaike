import { all, fork, take, put, call, select } from 'redux-saga/effects';
import { fetch } from '../reducers/inventoryDetail';
import { setTitle } from '../reducers/layout';
import callApi from '../services/callApi';
import { inventoryDetailSchema } from '../services/schemas';
import entitiesSelector from '../../utils/entitiesSelector';

function* watchFetch() {
  while (true) {
    yield take(fetch.request);
    const query = yield select(state => state.inventoryDetails.query);
    const { response, error } = yield call(() =>
      callApi('/inventory/show', {
        query: { ...query },
        schema: inventoryDetailSchema
      })
    );
    if (response) {
      yield put(
        fetch.success({ ...response.data, total: response.meta.total })
      );
      const inventoryDetails = yield select(state => entitiesSelector('inventoryDetails')(state))
      if (inventoryDetails && inventoryDetails.length > 0) {
        yield put(setTitle(inventoryDetails[0].debtorName))
      } else {
        yield put(setTitle(null))
      }
    } else {
      yield put(fetch.failure(error));
    }
  }
}

export default function* inventoryDetail() {
  yield all([fork(watchFetch)]);
}
