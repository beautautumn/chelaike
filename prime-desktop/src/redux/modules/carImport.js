import { createAction, createApiAction, createReducer } from 'rector/redux'

const initialState = {
  companies: [],
  progress: undefined,
}

export const search = createApiAction('carImport/SEARCH', companyName => ({
  method: 'get',
  endpoint: '/cars/import_search',
  query: { companyName },
}))

export const createImport = createApiAction('carImport/CREATE_IMPORT', importId => ({
  method: 'post',
  endpoint: '/cars/import',
  body: { importId },
}))

export const startPolling = createAction('carImport/START_POLLING')

export const stopPolling = createAction('carImport/STOP_POLLING')

export const fetchState = createApiAction('carImport/FETCH_STATE', () => ({
  method: 'get',
  endpoint: '/cars/import_status',
}))

const reducer = createReducer(on => {
  on(search.success, (state, payload) => ({
    ...state,
    companies: payload
  }))

  on(fetchState.success, (state, payload) => {
    if (typeof payload.pctComplete !== 'undefined') {
      return {
        ...state,
        progress: payload.pctComplete
      }
    }
    return state
  })
}, initialState)

export default reducer
