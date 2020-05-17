import { createAction, createApiAction, createReducer } from 'rector/redux'
import { TOKEN_KEY } from 'constants'
import cookie from 'react-cookie'

export const login = createApiAction('auth/LOGIN', user => ({
  method: 'post',
  endpoint: '/sessions',
  body: { user },
}), user => ({
  rememberMe: user.rememberMe,
}))

export const logout = createAction('auth/LOGOUT')
export const remberToken = createAction('auth/REMBER_TOKEN', token => (token))

export const signup = createApiAction('auth/SIGNUP', body => ({
  method: 'post',
  endpoint: '/registrations',
  body,
}))

export const fetchMe = createApiAction('auth/FETCH', () => ({
  method: 'get',
  endpoint: '/users/me',
}))

const initialState = {
  logging: false,
  registering: false
}

const reducer = createReducer(on => {
  on(login.request, state => ({
    ...state,
    logging: true,
  }))

  on(login.success, (state, payload) => ({
    ...state,
    error: null,
    logging: false,
    user: payload,
  }))

  on(login.error, (state, payload) => ({
    ...state,
    logging: false,
    error: payload,
  }))

  on(signup.request, state => ({
    ...state,
    registering: true,
  }))

  on(signup.success, (state, payload) => ({
    ...state,
    error: null,
    registering: false,
    user: payload,
  }))

  on(signup.error, state => ({
    ...state,
    user: null,
    registering: false,
  }))

  on(logout, state => ({
    ...state,
    user: {
      ...state.user,
      token: null
    }
  }))

  on(fetchMe.success, (state, payload, meta) => ({
    ...state,
    user: {
      ...payload,
      ...meta,
    }
  }))
}, initialState)

export default reducer

// 只给线上用就直接写死了
const domain = 'chelaike.com'

function saveCookie(token) {
  if (process.env.NODE_ENV !== 'production') return
  cookie.save(TOKEN_KEY, token, { path: '/', domain })
}

function removeCookie() {
  if (process.env.NODE_ENV !== 'production') return
  cookie.remove(TOKEN_KEY, { path: '/', domain })
}

export function saveToken(token, rememberMe = false) {
  const storage = rememberMe ? localStorage : sessionStorage
  storage.setItem(TOKEN_KEY, token)
  saveCookie(token)
}

export function getToken() {
  return localStorage.getItem(TOKEN_KEY) ||
    sessionStorage.getItem(TOKEN_KEY) ||
    cookie.load(TOKEN_KEY)
}

export function removeToken() {
  localStorage.removeItem(TOKEN_KEY)
  sessionStorage.removeItem(TOKEN_KEY)
  removeCookie()
}
