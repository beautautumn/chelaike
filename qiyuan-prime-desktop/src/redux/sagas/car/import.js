import { delay, takeEvery } from 'redux-saga'
import { call, take, fork, cancel, put, race } from 'redux-saga/effects'
import { show as showNotification } from 'redux/modules/notification'
import { createImport, startPolling, stopPolling, fetchState } from 'redux/modules/carImport'

function* polling() {
  yield put(fetchState())
  while (true) {
    yield call(delay, 5000)
    yield put(fetchState())
  }
}

function* watchStartPolling() {
  let lastTask
  while (true) {
    const action = yield race({
      start: take(startPolling.getType()),
      stop: take(stopPolling.getType()),
    })
    if (lastTask) {
      yield cancel(lastTask)
    }
    if (action.start) {
      lastTask = yield fork(polling)
    }
  }
}

function* watchImportSuccess() {
  yield* takeEvery(createImport.success.getType(), function* () {
    yield put(showNotification({
      type: 'success',
      message: '开始为您导入车辆，需要5-10分钟，请耐心等待，请勿重复导入',
    }))
    yield put(startPolling())
  })
}

function* watchImportError() {
  yield* takeEvery(createImport.error.getType(), function* (action) {
    yield put(showNotification({
      type: 'error',
      message: action.payload.message,
    }))
  })
}

export default function* root() {
  yield [
    fork(watchImportSuccess),
    fork(watchImportError),
    fork(watchStartPolling),
  ]
}
