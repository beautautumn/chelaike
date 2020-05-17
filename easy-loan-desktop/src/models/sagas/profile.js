import { all, fork, take, put, call } from 'redux-saga/effects';
import { fetch, loadAll } from '../reducers/profile';
import callApi from '../services/callApi';

function* watchProfileFetch() {
  while (true) {
    yield take(fetch.request);
    const profile = yield all({
      user: call(() => callApi('/users/me')),
      enums: call(() => callApi('/enumerize')),
      brands: call(() => callApi('/brands')),
      funders: call(() => callApi('/funder_company')),
      //funderCompanys: call(() => callApi('/funder_company')),
      userTypes: call(() => callApi('/users/type')),
      authorities: call(() => callApi('/authorities')),
      assignees: call(() => callApi('/assignee')),
      inventors: call(() => callApi('/inventor'))
    });

    let loaded = true;
    const keys = Object.getOwnPropertyNames(profile);
    for (let i = 0; i < keys.length; ++i) {
      const key = keys[i];
      const { response, error } = profile[key];
      if (response) {
        let result;
        if (
          key === 'assignees' ||
          key === 'inventors' ||
          key === 'funderCompanys' ||
          key === 'storesByDebtor'
        ) {
          result = response.data.map(item => ({
            id: `${item.id}`,
            name: item.name
          }));
        }
        if (key === 'userTypes') {
          result = response.data.map(item => ({
            type: `${item.type}`,
            name: item.name
          }));
        } else {
          result = response.data;
        }
        yield put(fetch.success({ [key]: result }));
      } else {
        loaded = false;
        yield put(fetch.failure(error));
      }
    }
    yield put(loadAll(loaded));
  }
}

export default function* profile() {
  yield all([fork(watchProfileFetch)]);
}
