import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'
import without from 'lodash/without'

export const fetch = createApiAction('roles/FETCH', () => ({
  method: 'get',
  endpoint: '/authority_roles',
  schema: Schemas.ROLE_ARRAY,
}))

export const fetchOne = createApiAction('roles/FETCH_ONE', id => ({
  method: 'get',
  endpoint: `/authority_roles/${id}`,
  schema: Schemas.ROLE,
}))

export const create = createApiAction('roles/CREATE', role => ({
  method: 'post',
  endpoint: '/authority_roles',
  schema: Schemas.ROLE,
  body: { authority_role: role },
}))

export const update = createApiAction('roles/UPDATE', role => ({
  method: 'put',
  endpoint: `/authority_roles/${role.id}`,
  schema: Schemas.ROLE,
  body: { authority_role: role },
}))

export const destroy = createApiAction('roles/DESTROY', id => ({
  method: 'del',
  endpoint: `/authority_roles/${id}`,
  schema: Schemas.ROLE,
}))

const initialState = {
  ids: [],
  fetching: false,
  fetched: false,
  saving: false
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetching: false
  }))

  on(fetch.success, (state, payload) => {
    if (Array.isArray(payload.result)) {
      return {
        ...state,
        ids: payload.result,
        fetching: false,
        fetched: true
      }
    }
    return state
  })

  const saveRequest = state => ({
    ...state,
    saving: true,
    saved: false
  })
  on(create.request, saveRequest)
  on(update.request, saveRequest)

  on(create.success, (state, payload) => ({
    ...state,
    ids: [...state.ids, payload.result],
    saving: false,
    saved: true
  }))

  on(update.success, state => ({
    ...state,
    saving: false,
    saved: true
  }))

  const saveError = state => ({
    ...state,
    saving: false,
    saved: false
  })
  on(create.error, saveError)
  on(update.error, saveError)

  on(destroy.request, state => ({
    ...state,
    destroyed: false
  }))

  on(destroy.success, (state, payload) => ({
    ...state,
    ids: without(state.ids, payload.result),
    destroyed: true
  }))
}, initialState)

export default reducer
