import callApi from './callApi'
import Cookies from 'universal-cookie'
import { TOKEN_KEY, PHONE_KEY } from '../../utils/constants'

const cookies = new Cookies()

function removeLocal(key) {
  localStorage.removeItem(key)
  sessionStorage.removeItem(key)
  cookies.remove(key, { path: '/' })
}

function saveLocal(key, value, rememberMe = false) {
  removeLocal(key)
  const storage = rememberMe ? localStorage : sessionStorage
  storage.setItem(key, value)
  cookies.set(key, value, { path: '/' })
}

function getLocal(key) {
  return localStorage.getItem(key) ||
    sessionStorage.getItem(key) ||
    cookies.get(key)
}

export const removeToken = () => removeLocal(TOKEN_KEY)
export const saveToken = (token, rememberMe) => saveLocal(TOKEN_KEY, token, rememberMe)
export const getToken = () => getLocal(TOKEN_KEY)
export const savePhone = (phone) => saveLocal(PHONE_KEY, phone, true)
export const getPhone = () => getLocal(PHONE_KEY)

export const requestLoginCode = phone => callApi('/session/verify_code',{
  method: 'post',
  body: { phone },
})

export const verifyloginCode = indentity => callApi('/session', {
  method: 'post',
  body: { ...indentity }
})


