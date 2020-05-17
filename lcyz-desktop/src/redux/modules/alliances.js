import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('alliances/FETCH', id => ({
  method: 'get',
  endpoint: `/cars/${id}/alliances`,
}))

export const update = createApiAction('alliances/UPDATE', params => ({
  method: 'put',
  endpoint: `/cars/${params.id}/alliances`,
  body: { alliances: params.alliances },
}))

export const fetchAlliancesByCompany = createApiAction('alliances/FETCHALLIANCE', () => ({
  method: 'get',
  endpoint: '/alliances',
}))

export const fetchCompaniesByAlliance = createApiAction('alliances/FETCHCOMPANY', id => ({
  method: 'get',
  endpoint: `/alliances/${id}/companies`,
}), (id, key) => ({
  key
}))

export const fetchShopsByCompany = createApiAction('alliances/FETCHSHOPSBYCOMPANY', id => ({
  method: 'get',
  endpoint: `/companies/${id}/shops`,
}), (id, key) => ({
  key
}))

const initialState = {
  saving: false,
  saved: false,
  data: [],
  fetching: false,
  fetched: false,
  companies: {},
  shops: {},
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

  on(fetchCompaniesByAlliance.request, (state) => ({
    ...state,
    fetching: true,
    fetched: false,
  }))
  on(fetchAlliancesByCompany.success, (state, payload) => ({
    ...state,
    data: payload,
    fetching: false,
    fetched: true,
  }))
  on(fetchCompaniesByAlliance.error, (state) => ({
    ...state,
    fetching: false,
    fetched: false,
  }))

  on(fetchCompaniesByAlliance.success, (state, payload, meta) => ({
    ...state,
    companies: {
      [meta.key]: payload
    }
  }))

  on(fetchShopsByCompany.success, (state, payload, meta) => ({
    ...state,
    shops: {
      [meta.key]: payload
    }
  }))
}, initialState)

export default reducer
