import { all, fork, take, put, call, select } from 'redux-saga/effects';
import { fetch, create, update, destory } from '../reducers/stores';
import callApi from '../services/callApi';
import { storesArraySchema } from '../services/schemas';
import { setTitle } from '../reducers/layout';
import entitiesSelector from '../../utils/entitiesSelector';

function* watchFetch() {
  while (true) {
    yield take(fetch.request);
    const query = yield select(state => state.stores.query);

    const { response, error } = yield call(() =>
      callApi(`/store/index`, {
        query: { ...query, page: query.page - 1 },
        schema: storesArraySchema
      })
    );
    if (response) {
      //console.log('response', response);
      yield put(
        fetch.success({ ...response.data, total: response.meta.total })
      );
      const stores = yield select(state => entitiesSelector('stores')(state))
      if (stores && stores.length > 0) {
        yield put(setTitle(stores[0].debtorName))
      } else {
        yield put(setTitle(null))
      }
    } else {
      yield put(fetch.failure(error));
    }
  }
}

function* watchCreate() {
  while (true) {
    const { payload } = yield take(create.request);
    const { response, error } = yield call(() =>
      callApi(`/store/create`, {
        body: payload,
        method: 'post'
      })
    );
    if (response) {
      yield put(create.success(response));
      yield put(fetch.request({ debtorId: payload.debtorId }));
    } else {
      yield put(create.failure(error));
    }
  }
}

function* watchUpdate() {
  while (true) {
    const { payload } = yield take(update.request);
    const { response, error } = yield call(() =>
      callApi(`/store/${payload.id}`, {
        body: payload,
        method: 'put'
      })
    );
    if (response) {
      yield put(update.success(response));
      yield put(fetch.request({ debtorId: payload.debtorId }));
    } else {
      yield put(update.failure(error));
    }
  }
}

function* watchDelete() {
  while (true) {
    const { payload } = yield take(destory.request);
    const { response, error } = yield call(() =>
      callApi(`/store/delete/${payload.id}`, {
        body: payload,
        method: 'delete'
      })
    );
    if (response) {
      yield put(destory.success(response));
      yield put(fetch.request({ debtorId: payload.debtorId }));
    } else {
      yield put(destory.failure(error));
    }
  }
}

export default function* stores() {
  yield all([
    fork(watchFetch),
    fork(watchCreate),
    fork(watchUpdate),
    fork(watchDelete)
  ]);
}
