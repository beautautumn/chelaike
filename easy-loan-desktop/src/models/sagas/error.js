import { all, fork, put, takeEvery } from 'redux-saga/effects'
import { push } from 'react-router-redux'
import { notification } from 'antd'

function* watchError() {
  const pattern = action => action.payload && action.payload.error
  yield takeEvery(pattern, function* (action) {
    const { code, data } = action.payload
    if (code === 401) {
      yield put(push('/login'))
    } else if (code === 404) {
      yield put(push('/404'))
    } else {
      notification.error({
        message: data.message,
        description: data.errors,
      })
    }
  })
}

export default function* error() {
  yield all([
    fork(watchError),
  ])
}
