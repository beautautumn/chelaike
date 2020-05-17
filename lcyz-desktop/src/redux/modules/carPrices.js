import { createApiAction, createReducer } from 'rector/redux'

export const create = createApiAction('carPrices/CREATE', (carId, price) => ({
  method: 'post',
  endpoint: `/cars/${carId}/car_price_histories`,
  body: { carPriceHistory: price },
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

/**
 * 计算新车完税价
 *
 * 新车完税价 = 新车实际价 + 购置税
 * 新车实际价格 = 新车指导价 + 加价 OR 新车指导价 × (1 - 优惠率)
 * 新车购置税 = (新车实际价 / (1 + 17%)) × 购置税率(10%)
 */
export function computeNewCarFinalPrice(newCarDiscount,
                                        newCarGuidePriceWan,
                                        newCarAdditionalPriceWan) {
  let newCarPrice
  if (newCarDiscount) {
    newCarPrice = +newCarGuidePriceWan * (1 - +newCarDiscount / 100)
  } else if (newCarAdditionalPriceWan) {
    newCarPrice = +newCarGuidePriceWan + +newCarAdditionalPriceWan
  } else {
    newCarPrice = +newCarGuidePriceWan
  }
  const newCarPurchaseTax = (newCarPrice / 1.17) * 0.1
  return +(newCarPrice + newCarPurchaseTax).toFixed(2)
}
