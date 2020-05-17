import { createApiAction, createReducer } from 'rector/redux'

export const create = createApiAction('carReservations/CREATE', (carId, reservation) => ({
  method: 'post',
  endpoint: `/cars/${carId}/car_reservation`,
  body: { carReservation: reservation },
}))

export const update = createApiAction('carReservations/UPDATE', (carId, reservation) => ({
  method: 'put',
  endpoint: `/cars/${carId}/car_reservation`,
  body: { carReservation: reservation },
}))

export const fetch = createApiAction('carReservations/FETCH', carId => ({
  method: 'get',
  endpoint: `/cars/${carId}/car_reservation`,
}))

export const cancel = createApiAction('carReservations/CANCEL', (carId, reservation) => ({
  method: 'put',
  endpoint: `/cars/${carId}/car_reservation/cancel`,
  body: { cancelReservation: reservation },
}))

const initialState = {
  saving: false
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetch: false
  }))

  on(fetch.success, (state, payload) => ({
    ...state,
    currentReservation: payload,
  }))

  const saveRequest = state => ({
    ...state,
    error: null,
    saving: true,
    saved: false
  })
  on(create.request, saveRequest)
  on(update.request, saveRequest)
  on(cancel.request, saveRequest)

  const saveSuccess = state => ({
    ...state,
    saving: false,
    saved: true
  })
  on(create.success, saveSuccess)
  on(update.success, saveSuccess)
  on(cancel.success, saveSuccess)

  const saveError = (state, payload) => ({
    ...state,
    saving: false,
    saved: false,
    error: payload.message,
  })
  on(create.error, saveError)
  on(cancel.error, saveError)
}, initialState)

export default reducer
