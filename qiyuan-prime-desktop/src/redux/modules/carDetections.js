import { createApiAction, createReducer } from 'rector/redux'

export const create = createApiAction('carDetections/CREATE', (carId, detection) => ({
  method: 'post',
  endpoint: `/cars/${carId}/detection_reports`,
  body: { detectionReport: detection },
}))

export const update = createApiAction('carDetections/UPDATE', (carId, detection) => ({
  method: 'put',
  endpoint: `/cars/${carId}/detection_reports`,
  body: { detectionReport: detection },
}))

export const fetch = createApiAction('carDetections/FETCH', carId => ({
  method: 'get',
  endpoint: `/cars/${carId}/detection_reports`,
}))

const initialState = {
  saving: false
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetch: false,
    saved: false,
    saving: false,
  }))

  on(fetch.success, (state, payload) => ({
    ...state,
    currentDetection: payload,
  }))

  const saveRequest = state => ({
    ...state,
    error: null,
    saving: true,
    saved: false
  })
  on(create.request, saveRequest)
  on(update.request, saveRequest)

  const saveSuccess = state => ({
    ...state,
    saving: false,
    saved: true
  })
  on(create.success, saveSuccess)
  on(update.success, saveSuccess)

  const saveError = (state, payload) => ({
    ...state,
    saving: false,
    saved: false,
    error: payload.message,
  })
  on(create.error, saveError)
  on(update.error, saveError)
}, initialState)

export default reducer
