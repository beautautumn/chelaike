import { createApiAction, createReducer } from 'rector/redux'

export const fetchContacts = createApiAction('platform/contacts/fetch', () => ({
  method: 'get',
  endpoint: '/platform_profiles/contacts',
}))
export const fetchStatus = createApiAction('platform/state/fetch', params => ({
  method: 'get',
  endpoint: '/platform_profiles/sync_states',
  query: params,
}))
export const fetchMissingFields = createApiAction('platform/missingFields/fetch', params => ({
  method: 'get',
  endpoint: '/platform_profiles/validate_missings',
  query: params,
}))

export const publish = createApiAction('platform/publish', params => ({
  method: 'post',
  endpoint: `/cars/${params.carId}/publishers/publish`,
  query: params,
}))
export const deletePublish = createApiAction('platform/del_publish', params => ({
  method: 'del',
  endpoint: `/cars/${params.carId}/publishers/publishers`,
  query: { platform: params.platform },
}))

const initialState = {
  spinning: false
}

const reducer = createReducer((on) => {
  on(fetchContacts.success, (state, payload) => ({
    ...state,
    contacts: payload.contacts
  }))
  on(fetchStatus.success, (state, payload) => ({
    ...state,
    syncStates: payload
  }))


  on(fetchMissingFields.request, (state) => ({
    ...state,
    spinning: true
  }))
  on(fetchMissingFields.success, (state, payload) => ({
    ...state,
    missingFields: payload.missingFields,
    spinning: false
  }))
  on(fetchMissingFields.error, (state) => ({
    ...state,
    spinning: false
  }))

  on(publish.request, (state) => ({
    ...state,
    saved: false,
    saving: true
  }))
  on(publish.success, (state) => ({
    ...state,
    saved: true,
    saving: false
  }))
  on(publish.error, (state) => ({
    ...state,
    saved: false,
    saving: false
  }))

  on(deletePublish.request, (state) => ({
    ...state,
    spinning: true
  }))
  on(deletePublish.success, (state) => ({
    ...state,
    spinning: false }))
  on(deletePublish.error, (state) => ({
    ...state,
    spinning: false
  }))
}, initialState)

export default reducer
