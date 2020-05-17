import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'


export const fetch = createApiAction('importTasks/FETCH', query => ({
  method: 'get',
  endpoint: '/import_tasks',
  schema: Schemas.IMPORT_TASK_ARRAY,
  query,
}), query => ({
  query,
}))

const initialState = {
  ids: [],
  fetchParams: {
    page: 1,
  }
}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload, meta) => ({
    ...state,
    ids: payload.result,
    fetchParams: meta.query,
  }))
}, initialState)

export default reducer
