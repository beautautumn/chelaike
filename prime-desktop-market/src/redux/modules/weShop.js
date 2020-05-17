import { createApiAction, createReducer } from 'rector/redux'

export const fetchMenus = createApiAction('customMenu/FETCH', () => ({
  method: 'get',
  endpoint: '/weshop/menus',
}))

export const updateMenu = createApiAction('customMenu/UPDATE', menus => ({
  method: 'put',
  endpoint: '/weshop/menus',
  body: { menus },
}))

export const publishMenu = createApiAction('customMenu/PUBLISH', () => ({
  method: 'post',
  endpoint: '/weshop/menus/publish',
}))

export const authorization = createApiAction('authorization/FETCH', () => ({
  method: 'get',
  endpoint: '/wechats/authorization',
}))

const initialState = {
  customMenus: {}
}

const reducer = createReducer(on => {
  on(fetchMenus.success, (state, payload) => ({
    ...state,
    customMenus: payload
  }))

  on(updateMenu.success, (state, payload) => ({
    ...state,
    customMenus: payload
  }))

  on(publishMenu.success, (state, payload) => ({
    ...state,
    customMenus: payload
  }))

  on(authorization.success, (state, payload) => ({
    ...state,
    authorization: payload
  }))
}, initialState)

export default reducer
