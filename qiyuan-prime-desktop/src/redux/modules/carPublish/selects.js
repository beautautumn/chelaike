import { createAction, createApiAction, createReducer } from 'rector/redux'

export const fetchBrands = createApiAction('platform/brans/FETCH', params => ({
  method: 'get',
  endpoint: '/platform_profiles/brands',
  query: params,
}))

export const fetchSeries = createApiAction('platform/series/FETCH', params => ({
  method: 'get',
  endpoint: '/platform_profiles/series',
  query: params,
}))

export const fetchStyles = createApiAction('platform/styles/FETCH', params => ({
  method: 'get',
  endpoint: '/platform_profiles/styles',
  query: params,
}))

export const reset = createAction('reset data of series and styles')

const initialState = {
  brands: null,
  series: null,
  styles: null,
  fetching: false,
  fetched: false
}

const reducer = createReducer((on) => {
  on(fetchBrands.request, (state) => ({
    ...state,
    fetching: true
  }))
  on(fetchBrands.success, (state, res) => ({
    ...state,
    brands: res.brands,
    fetching: false,
    fetched: true
  }))

  on(fetchSeries.success, (state, res) => ({
    ...state,
    series: res.series
  }))

  on(fetchStyles.success, (state, res) => ({
    ...state,
    styles: res.styles
  }))

  on(reset, (state) => ({
    ...state,
    styles: null,
    series: null
  }))
}, initialState)

export default reducer

