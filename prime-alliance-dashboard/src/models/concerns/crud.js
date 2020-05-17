import without from 'lodash/without'

export default function crud({ create, fetch, update, destroy }) {
  const handleSaveRequst = (state) => ({ ...state, saving: true, saved: false })
  const handleSaveError = (state) => ({ ...state, saving: false, saved: false })

  return on => {
    if (create) {
      on(create.request, handleSaveRequst)
      on(create.error, handleSaveError)

      on(create.success, (state, payload) => ({
        ...state,
        ids: [payload.result, ...state.ids],
        saving: false,
        saved: true,
      }))
    }

    if (fetch) {
      on(fetch.request, (state) => ({
        ...state,
        fetching: true,
        fetched: false,
      }))

      on(fetch.success, (state, payload) => ({
        ...state,
        ids: payload.result,
        fetching: false,
        fetched: true,
      }))
    }

    if (update) {
      on(update.request, handleSaveRequst)
      on(update.error, handleSaveError)

      on(update.success, (state) => ({
        ...state,
        saving: false,
        saved: true,
      }))
    }

    if (destroy) {
      on(destroy.request, (state) => ({
        ...state,
        destroyed: false,
      }))

      on(destroy.success, (state, payload) => (
        {
          ...state,
          ids: without(state.ids, payload.result),
          destroyed: true,
        }
      ))
    }
  }
}
