import feeble from 'feeble'
import { TOKEN_KEY } from 'config/constants'
import { takeEvery, delay } from 'feeble/saga'
import { call, put, fork, select } from 'feeble/saga/effects'
import { replaceState } from './concerns/hydratable'
import { push } from 'react-router-redux'

const model = feeble.model({
  namespace: 'auth',
  state: {
    logging: false,
  },
})

model.apiAction('login', user => ({
  method: 'post',
  endpoint: '/sessions',
  body: { user },
}), user => ({
  rememberMe: user.rememberMe,
}))

model.action('logout')

model.apiAction('fetchMe', () => ({
  method: 'get',
  endpoint: '/users/me',
}))

model.reducer(on => {
  on(model.login.request, (state) => ({
    ...state,
    logging: true,
  }))

  on(model.login.success, (state, payload) => ({
    ...state,
    error: null,
    logging: false,
    user: payload,
  }))

  on(model.login.error, (state, payload) => ({
    ...state,
    logging: false,
    error: payload.message,
  }))

  on(model.fetchMe.success, (state, payload) => ({
    ...state,
    user: payload,
  }))
})

export function getToken() {
  return localStorage.getItem(TOKEN_KEY) || sessionStorage.getItem(TOKEN_KEY)
}

function saveToken(token, rememberMe = false) {
  const storage = rememberMe ? localStorage : sessionStorage
  storage.setItem(TOKEN_KEY, token)
}

function removeToken() {
  localStorage.removeItem(TOKEN_KEY)
  sessionStorage.removeItem(TOKEN_KEY)
}

function saveUserToGlobal(user) {
  global.PrimeAllianceDashboard.currentUser = user
}

function getRouting(state) {
  return state.routing
}

function* watchLogin() {
  yield* takeEvery(model.login.success, function* ({ payload, meta }) {
    yield call(saveToken, payload.token, meta.rememberMe)
    yield put(push('/'))
  })
}

function* watchLogout() {
  yield* takeEvery(model.logout, function* () {
    yield put(push('/login'))
    yield delay(0)
    yield call(removeToken)

    const { initialState } = global.PrimeAllianceDashboard
    const routing = yield select(getRouting)

    yield put(replaceState({
      ...initialState,
      routing,
    }))
  })
}

function* watchFetchMe() {
  yield takeEvery(model.fetchMe.success, function* ({ payload }) {
    yield call(saveUserToGlobal, payload)
  })
}

function* watchUnauthorized() {
  const pattern = action => action.meta &&
    action.meta.status === 401 &&
    action.type !== model.login.error.getType()
  yield takeEvery(pattern, function* () {
    yield put(push('/login'))
  })
}

model.effect(function* () {
  yield [
    fork(watchLogin),
    fork(watchLogout),
    fork(watchFetchMe),
    fork(watchUnauthorized),
  ]
})

export default model
