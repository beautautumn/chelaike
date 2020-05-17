import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('styles/FETCH', series => ({
  method: 'get',
  endpoint: '/styles',
  query: { series: { name: series } },
}), (series, key) => ({
  key,
}))

export const fetchDetail = createApiAction('styles/DETAIL_FETCH', (series, style) => ({
  method: 'get',
  endpoint: '/style',
  query: {
    series: { name: series },
    style: { name: style }
  },
}))

const initialState = {}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload, meta) => {
    const data = payload.reduce((accumulator, style) => ([
      ...accumulator,
      ...style.models
    ]), [])
    return {
      ...state,
      [meta.key]: data
    }
  })

  on(fetchDetail.request, state => ({
    ...state,
    detailFetched: false
  }))

  on(fetchDetail.success, (state, payload) => ({
    ...state,
    features: payload.carConfiguration,
    recommendedPrice: payload.price,
    detailFetched: true
  }))

  on(fetchDetail.error, state => ({
    ...state,
    detailFetched: false
  }))
}, initialState)

export default reducer
