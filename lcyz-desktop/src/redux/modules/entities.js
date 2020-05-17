import { createAction, createReducer } from 'rector/redux'
import { create as carStateCreate } from './carStates'
import { create as carPriceCreate } from './carPrices'
import merge from 'lodash/fp/merge'
import mapValues from 'lodash/mapValues'
import {
  create as carReservationCreate,
  cancel as carReservationCancel
} from './carReservations'
import {
  create as intentionPushHistoryCreate
} from './intentionPushHistories'

export const update = createAction('entities/UPDATE', (name, id, data) => ({
  name,
  id,
  data
}))

const initialState = {}

const reducer = createReducer(on => {
  on(action => action && action.payload && action.payload.entities, (state, payload) => ({
    ...state,
    ...(mapValues(payload.entities, (entities, key) => ({
      ...state[key],
      ...mapValues(entities, (entity, id) => {
        if (state[key]) {
          return { ...state[key][id], ...entity }
        }
        return entity
      })
    })))
  }))

  on(update, (state, payload) =>
    merge(state, {
      [payload.name]: {
        [payload.id]: payload.data,
      },
    })
  )

  on(carStateCreate.success, (state, payload) =>
    merge(state, {
      cars: {
        [payload.carId]: {
          stateNote: payload.note,
          state: payload.state
        }
      }
    })
  )

  on(carPriceCreate.success, (state, payload) =>
    merge(state, {
      cars: {
        [payload.carId]: payload
      }
    })
  )

  on(carReservationCreate.success, (state, payload) =>
    merge(state, {
      cars: {
        [payload.carId]: {
          reserved: true,
        }
      }
    })
  )

  on(carReservationCancel.success, (state, payload) =>
    merge(state, {
      cars: {
        [payload.carId]: {
          reserved: false,
        }
      }
    })
  )

  on(intentionPushHistoryCreate.success, (state, payload) => {
    const intentionPushHistory = payload.entities.intentionPushHistories[payload.result]
    return merge(state, {
      intentions: {
        [intentionPushHistory.intentionId]: {
          latestIntentionPushHistory: payload.result
        }
      }
    })
  })
}, initialState)

export default reducer
