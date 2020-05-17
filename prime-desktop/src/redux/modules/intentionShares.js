import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('intentionShares/FETCH', id => ({
  method: 'get',
  endpoint: `/intention/${id}/share`,
}))

export const update = createApiAction('intentionShares/UPDATE', params => ({
  method: 'put',
  endpoint: `/intentions/${params.id}/share`,
  body: params,
}))

const initialState = {
  saving: false,
  saved: false,
}

const reducer = createReducer((on) => {
  on(fetch.success, (state, payload) => ({
    ...state,
    ...payload
  }))

  on(update.request, (state) => ({
    ...state,
    saving: true,
    saved: false,
  }))

  on(update.success, (state) => ({
    ...state,
    saving: false,
    saved: true,
  }))

  on(update.error, (state) => ({
    ...state,
    saving: false,
    saved: false,
  }))
}, initialState)

export default reducer
