export default function query(fetch) {
  return on => {
    on(fetch.request, (state, payload, meta) => ({
      ...state,
      query: meta.query || {},
    }))
  }
}
