import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'

export const fetch = createApiAction('intentionPushHistories/FETCH', intentionId => ({
  method: 'get',
  endpoint: `/intentions/${intentionId}/intention_push_histories`,
  schema: Schemas.INTENTION_PUSH_HISTORY_ARRAY,
}))

export const create = createApiAction('intentionPushHistories/CREATE',
  (intentionId, intentionPushHistory) => ({
    method: 'post',
    endpoint: `/intentions/${intentionId}/intention_push_histories`,
    schema: Schemas.INTENTION_PUSH_HISTORY,
    body: { intentionPushHistory },
  })
)

const initialState = {
  ids: []
}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload) => ({
    ...state,
    ids: payload.result
  }))

  on(create.request, state => ({
    ...state,
    saved: false
  }))

  on(create.success, state => ({
    ...state,
    saved: true
  }))
}, initialState)

export default reducer
