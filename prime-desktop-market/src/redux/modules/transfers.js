import { createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'

export const update = createApiAction('transfers/UPDATE', (carId, type, transfer) => {
  const name = `${type}_transfer`

  return {
    method: 'put',
    endpoint: `/cars/${carId}/${name}`,
    schema: Schemas.TRANSFER,
    body: { [name]: transfer },
  }
})

const initialState = {
  saving: false
}

const reducer = createReducer(on => {
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
