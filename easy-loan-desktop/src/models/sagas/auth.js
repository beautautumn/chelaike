import { all, fork, take, put, call, select } from 'redux-saga/effects'
import { push } from 'react-router-redux'
import { code, login, logout } from '../reducers/auth'
import { reset } from '../reducers/profile'
import {
  requestLoginCode,
  verifyloginCode,
  saveToken,
  savePhone,
  removeToken,
} from '../services/auth'

function* watchCode() {
  while (true) {
    const { payload } = yield take(code.request)
    const { error } = yield call(requestLoginCode, payload)
    if (error) {
      yield put(code.failure(error))
    }
  }
}

function* watchLogin() {
  while (true) {
    const { payload: { rememberMe, ...indentity} } = yield take(login.request)
    const { response, error } = yield call(verifyloginCode, indentity)
    if (response) {
      yield call(saveToken, response.data.token, rememberMe)
      yield call(savePhone, indentity.phone)
      yield put(login.success(response.data))
      const preUrl = yield select(state => {
        const locationState = state.router.location.state
        if (locationState &&
            locationState.from &&
            locationState.from.pathname !== '/login') {
          return locationState.from.pathname
        }
        return '/loans'
      })
      yield put(push(preUrl))
    } else {
      yield put(login.failure(error))
    }
  }
}

function* watchLogout() {
  while (true) {
    yield take(logout)
    yield call(removeToken)
    yield put(reset())
    yield put(push('/login'))
  }
}

export default function* auth() {
  yield all([
    fork(watchCode),
    fork(watchLogin),
    fork(watchLogout),
  ])
}
