import Schemas from '../schemas'
import { crud, query, pagination } from './concerns'
import { createApiAction, createReducer, composeReducers } from 'rector/redux'

export const fetchCities = createApiAction('export/CITIES', () => ({
  method: 'get',
  endpoint: '/companies/cities_name'
}))

export const fetchShops = createApiAction('export/SHOPS', city => ({
  method: 'get',
  endpoint: '/shops/query_city',
  query: { city }
}), city => ({
  city
}))

export const fetchCompanies = createApiAction('export/COMPANIES', shopId => ({
  method: 'get',
  endpoint: '/owner_companies/query_shop',
  query: { shopId }
}), shopId => ({
  shopId
}))

export const fetchUsers = createApiAction('export/USERS', shopId => ({
  method: 'get',
  endpoint: '/users/query_shop',
  query: { shopId }
}), shopId => ({
  shopId
}))

export const exportSearchForm = createReducer(on => {
  on(fetchCities.request, state => state)
  on(fetchCities.success, (state, payload) => {
    if (payload) {
      return {
        ...state,
        cities: payload.map(item => ({ value: item, text: item }))
      }
    }
    return {
      ...state,
      cities: []
    }
  })
  on(fetchCities.error, state => state)

  on(fetchShops.request, state => state)
  on(fetchShops.success, (state, payload) => {
    if (payload) {
      return {
        ...state,
        shops: payload.map(item => ({ value: `${item.id}`, text: item.name }))
      }
    }

    return {
      ...state,
      shops: []
    }
  })
  on(fetchShops.error, state => state)

  on(fetchCompanies.request, state => state)
  on(fetchCompanies.success, (state, payload) => {
    if (payload) {
      return {
        ...state,
        companies: payload.map(item => ({ value: `${item.id}`, text: item.name }))
      }
    }
    return {
      ...state,
      companies: []
    }
  })
  on(fetchCompanies.error, state => state)

  on(fetchUsers.request, state => state)
  on(fetchUsers.success, (state, payload) => {
    if (payload) {
      return {
        ...state,
        users: payload.map(item => ({ value: `${item.id}`, text: item.name }))
      }
    }
    return {
      ...state,
      users: []
    }
  })
  on(fetchUsers.error, state => state)
}, { cities: [], shops: [], companies: [], users: [] })


export const fetchStockReports = createApiAction('export/STOCK_REPORTS', query => ({
  method: 'get',
  endpoint: '/reports',
  schema: Schemas.EXPORT_STOCK_REPORT_ARRAY,
  query: { ...query, reportType: 'bm_cars' }
}), query => ({
  query
}))

export const fetchSaleReports = createApiAction('export/SALE_REPORTS', query => ({
  method: 'get',
  endpoint: '/reports',
  schema: Schemas.EXPORT_SALE_REPORT_ARRAY,
  query: { ...query, reportType: 'bm_sold_out' }
}), query => ({
  query
}))

export const fetchCustomerReports = createApiAction('export/CUSTOMER_REPORTS', query => ({
  method: 'get',
  endpoint: '/reports',
  schema: Schemas.EXPORT_CUSTOMER_REPORT_ARRAY,
  query: { ...query, reportType: 'bm_intention' }
}), query => ({
  query
}))

export const exportStockReports = composeReducers(
  createReducer({}, {
    ids: [],
    query: {},
    total: 0,
    fetching: false,
    fetched: false
  }),
  crud({ fetch: fetchStockReports }),
  query(fetchStockReports),
  pagination(fetchStockReports)
)

export const exportSaleReports = composeReducers(
  createReducer({}, {
    ids: [],
    query: {},
    total: 0,
    fetching: false,
    fetched: false
  }),
  crud({ fetch: fetchSaleReports }),
  query(fetchSaleReports),
  pagination(fetchSaleReports)
)

export const exportCustomerReports = composeReducers(
  createReducer({}, {
    ids: [],
    query: {},
    total: 0,
    fetching: false,
    fetched: false
  }),
  crud({ fetch: fetchCustomerReports }),
  query(fetchCustomerReports),
  pagination(fetchCustomerReports)
)
