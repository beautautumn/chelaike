import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('platform/fetch', () => ({
  method: 'get',
  endpoint: '/platform_profiles',
}))

export const update = createApiAction('platform/update', profile => ({
  method: 'put',
  endpoint: '/platform_profiles',
  body: { profile },
}))

export const destroy = createApiAction('platform/destory', platform => ({
  method: 'del',
  endpoint: '/platform_profiles',
  body: { platform },
}))

const initialState = {
}

const reducer = createReducer((on) => {
  on(fetch.success, (state, payload) => ({
    ...state,
    platformProfile: payload.platformProfile
  }))

  on(update.request, (state) => ({
    ...state,
    saved: false,
    saving: true
  }))
  on(update.success, (state, payload) => ({
    ...state,
    saved: true,
    saving: false,
    platformProfile: payload.platformProfile
  }))
  on(update.error, (state) => ({
    ...state,
    saved: false,
    saving: false
  }))

  on(destroy.success, (state, payload) => ({
    ...state,
    platformProfile: payload.platformProfile
  }))
}, initialState)

export default reducer
