import { createApiAction, createReducer, composeReducers } from 'rector/redux'
import { crud, pagination, query } from '../concerns'
import Schemas from '../../schemas'

export const fetch = createApiAction('financeSingleCar/FETCH', query => ({
  method: 'get',
  endpoint: '/finance/car_incomes',
  schema: Schemas.FINANCESINGLECAR_ARRAY,
  query: { ...query, perPage: 6 },
}), query => ({
  query,
}))

export const fetchFees = createApiAction('financeSingleCar/FETCHFEES', (carId, category) => ({
  method: 'get',
  endpoint: `/cars/${carId}/finance/car_fees?category=${category}`,
}))


export const update = createApiAction('financeSingleCar/UPDATE', (carId, body) => ({
  method: 'put',
  endpoint: `/cars/${carId}/finance/car_fees/batch_update`,
  schema: Schemas.FINANCESINGLECAR,
  body,
}))

export const updateStockPrice = createApiAction(
  'financeSingleCar/UPDATESTOCKPRICE',
  (id, body) => ({
    method: 'put',
    endpoint: `/finance/car_incomes/${id}/update_price`,
    schema: Schemas.FINANCESINGLECAR,
    body,
  })
)

export const updateFundRate = createApiAction(
  'financeSingleCar/UPDATEFUNDRATE',
  (id, financeCarIncome) => ({
    method: 'put',
    endpoint: `/finance/car_incomes/${id}/update_fund_rate`,
    schema: Schemas.FINANCESINGLECAR,
    body: { financeCarIncome },
  })
)

const initialState = {
  ids: [],
  query: {},
  total: 0,
  fetching: false,
  fetched: false,
  saving: false,
  saved: false,
}

const updateReducer = (action, on) => {
  on(action.request, (state) => ({
    ...state,
    saving: true,
    saved: false,
  }))
  on(action.success, (state) => ({
    ...state,
    saving: false,
    saved: true,
  }))
  on(action.error, (state) => ({
    ...state,
    saving: false,
    saved: false,
  }))
}

const reducer = createReducer((on) => {
  updateReducer(updateStockPrice, on)
  updateReducer(updateFundRate, on)

  on(fetchFees.success, (state, payload) => ({
    ...state,
    fees: payload,
  }))
}, initialState)

const finnalReducer = composeReducers(
  reducer,
  crud({ fetch, update }),
  pagination(fetch),
  query(fetch),
)

export default finnalReducer
