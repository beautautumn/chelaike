import { createReducer } from 'rector/redux'

export default function query(fetch) {
  return createReducer(on => {
    on(fetch.request, (state, payload, meta) => ({
      ...state,
      query: meta.query || {},
    }))
  })
}
