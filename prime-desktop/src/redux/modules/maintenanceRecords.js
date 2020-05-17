import { createApiAction, createReducer } from 'rector/redux'

export const fetch = createApiAction('maintenanceRecord/FETCH', id => ({
  method: 'get',
  endpoint: '/maintenance_records/detail',
  query: { query: { carId: id } },
}))

export const update = createApiAction('', (id, images) => ({
  method: 'post',
  endpoint: '/maintenance_records/upload_images',
  body: { carId: id, maintenanceImagesAttributes: images },
}))

const initialState = {
  data: null,
}

const reducer = createReducer(on => {
  on(fetch.success, (state, payload) => ({
    ...state,
    data: payload,
  }))
  on(update.success, (state, payload) => ({
    data: {
      ...state.data,
      maintenanceImages: payload.maintenanceImages
    },
  }))
}, initialState)

export default reducer
