import { createApiAction, createReducer } from 'rector/redux'

export const create = createApiAction('carStates/CREATE', (carId, state) => ({
  method: 'post',
  endpoint: `/cars/${carId}/car_state_histories`,
  body: { carStateHistory: state },
}))

const initialState = {
  saving: false
}

const reducer = createReducer(on => {
  on(create.request, state => ({
    ...state,
    saving: true,
    saved: false
  }))

  on(create.success, state => ({
    ...state,
    saving: false,
    saved: true
  }))

  on(create.error, state => ({
    ...state,
    saving: false,
    saved: false
  }))
}, initialState)

export default reducer
