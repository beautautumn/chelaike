import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'

export const fetch = createApiAction('prepare/record/FETCH', carId => ({
  method: 'get',
  endpoint: `/cars/${carId}/prepare_record`,
}))

export const update = createApiAction('prepare/record/UPDATE', (carId, prepareRecord) => ({
  method: 'put',
  endpoint: `/cars/${carId}/prepare_record`,
  schema: Schemas.PREPARE_RECORD,
  body: { prepareRecord },
}))

const initialState = {
  saving: false
}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload) => ({
    ...state,
    currentPrepareRecord: payload,
  }))

  on(update.request, state => ({
    ...state,
    saving: true,
    saved: false
  }))

  on(update.success, state => ({
    ...state,
    saving: false,
    saved: true
  }))

  on(update.error, state => ({
    ...state,
    saving: false,
    saved: false
  }))
}, initialState)

export default reducer
