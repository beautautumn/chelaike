import { takeEvery, takeLatest, delay } from 'redux-saga'
import { take, call, put, fork, select } from 'redux-saga/effects'
import {
  login,
  signup,
  fetchMe,
  logout,
  saveToken,
  removeToken,
} from 'redux/modules/auth'
import { replaceState } from 'redux/modules/makeHydratable'
import { push } from 'react-router-redux'

export function saveUserToGlobal(user) {
  global.PrimeDesktop.currentUser = user
}

export function getRouting(state) {
  return state.routing
}

export function* processLogin(user, rememberMe) {
  yield call(saveToken, user.token, rememberMe)
  yield put(push('/cars'))
}

export function* processLogout() {
  yield put(push('/login'))
  // 等待页面加载完毕后再清空用户信息
  yield delay(0)
  yield call(removeToken)
  yield call(saveUserToGlobal, null)

  const { initialState } = global.PrimeDesktop
  const routing = yield select(getRouting)

  yield put(replaceState({
    ...initialState,
    routing
  }))
}

export function* watchLogin() {
  const pattern = action =>
    [login.success.getType(), signup.success.getType()].includes(action.type)
  while (true) {
    const { payload, meta } = yield take(pattern)
    yield fork(processLogin, payload, meta.rememberMe)
  }
}

export function* watchLogout() {
  while (true) {
    yield take(logout.getType())
    yield fork(processLogout)
  }
}

export function* watchFetchCurrentUser() {
  yield takeLatest(fetchMe.success.getType(), function* ({ payload }) {
    yield call(saveUserToGlobal, payload)
  })
}

export function* watchUnauthorized() {
  const pattern = action => action.meta &&
    action.meta.status === 401 &&
    action.type !== login.error.getType()
  yield takeEvery(pattern, function* () {
    yield put(push('/login'))
  })
}

export default function* root() {
  yield [
    fork(watchLogin),
    fork(watchLogout),
    fork(watchFetchCurrentUser),
    fork(watchUnauthorized)
  ]
}
