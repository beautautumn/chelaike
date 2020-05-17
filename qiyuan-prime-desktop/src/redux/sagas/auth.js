import { takeEvery, takeLatest, delay } from 'redux-saga'
import { take, call, put, fork, select } from 'redux-saga/effects'
import {
  login,
  signup,
  fetchMe,
  logout,
  saveToken,
  removeToken,
  remberToken,
} from 'redux/modules/auth'
import { show as showNotification } from 'redux/modules/notification'
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
  yield put(push('/'))
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
    [login.success.getType()].includes(action.type)
  while (true) {
    const { payload, meta } = yield take(pattern)
    yield fork(processLogin, payload, meta.rememberMe)
  }
}

export function* watchSignup() {
  const pattern = action =>
    [signup.success.getType()].includes(action.type)
  while (true) {
    yield take(pattern)
    yield put(showNotification({
      type: 'success',
      message: '注册成功，将跳转系统登录页',
    }))
    setTimeout(() => {
      window.location.href = 'http://market.chelaike.com/sso/login'
    }, 2000)
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

export function* watchRemberToken() {
  while (true) {
    const { payload } = yield take(remberToken.getType())
    yield call(saveToken, payload, true)
  }
}

export default function* root() {
  yield [
    fork(watchLogin),
    fork(watchLogout),
    fork(watchFetchCurrentUser),
    fork(watchUnauthorized),
    fork(watchRemberToken),
    fork(watchSignup)
  ]
}
