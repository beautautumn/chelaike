import { DETAIL_FETCH_SUCCESS } from '../style'
import { actionTypes } from 'redux-form'
import findKey from 'lodash/findKey'
import dateFormat from 'helpers/date'
import { CREATE_FAILURE, UPDATE_FAILURE } from '../car'
import mapValues from 'lodash/mapValues'

export const SYNC_FEATURES = 'prime/form/car/SYNC_FEATURES'
export const APPLY_STYLE_DETAIL = 'prime/form/car/APPLY_STYLE_DETAIL'
export const AUTO_FILL_EXPIRATION_DATES = 'prime/form/car/AUTO_FILL_EXPIRATION_DATES'

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

/**
 * 根据上牌日期，计算交强险到期日和年审到期日
 *
 * 交强险到期日：未来最近的一个上牌月，简称 未来月
 *
 * 上牌日期 距离 未来月 小于6年：
 *    如果未来月与上牌日的年数差是奇数，年审到期日：未来月＋1年
 *    如果未来月与上牌日的年数差是偶数，年审到期日：未来月
 * 上牌日期 距离 未来月 大于等于6年：
 *    年审到期日：未来月
 */
function computeExpirationDates(licensedAt) {
  const licensedAtDate = new Date(`${licensedAt}-01`)
  const now = new Date()

  const year = now.getMonth() > licensedAtDate.getMonth() ?
    now.getFullYear() + 1 : now.getFullYear()
  const month = licensedAtDate.getMonth()
  const futureMonth = new Date(year, month, 1)

  const annualInspectionEndDate = new Date(year, month, 1)
  const differenceOfYear = futureMonth.getFullYear() - licensedAtDate.getFullYear()
  if (differenceOfYear < 6 && differenceOfYear % 2 === 1) {
    annualInspectionEndDate.setFullYear(year + 1)
  }

  return {
    compulsoryInsurance: true,
    compulsoryInsuranceEndAt: dateFormat(futureMonth, 'short'),
    annualInspectionEndAt: dateFormat(annualInspectionEndDate, 'short'),
  }
}

function getTransmissionKey(enumValues, transmission) {
  return findKey(enumValues.car.transmission, (value) => value.startsWith(transmission))
}

function getCarTypeKey(enumValues, type) {
  return findKey(enumValues.car.car_type, (value) => value === type)
}

function getEmissionStandardKey(enumValues, emissionStandard) {
  const key = findKey(enumValues.emission_standard, (value) => value === emissionStandard)
  if (key) return key
  if (!emissionStandard.startsWith('欧')) return null
  const guoEmissionStandard = emissionStandard.replace('欧', '国')
  return findKey(enumValues.emission_standard, (value) => value === guoEmissionStandard)
}

function getFuelTypeKey(enumValues, fuelType) {
  const key = findKey(enumValues.car.fuel_type, (value) => value === fuelType)
  if (key) return key
  return 'other'
}


/**
 * 从车款详情中提取出车辆属性
 */
function extractCarFields(enumValues, features, recommendedPrice) {
  const car = {}
  if (recommendedPrice.guidePrice) {
    car.newCarGuidePriceWan = +(recommendedPrice.guidePrice / 10000).toFixed(2)
  }
  features.forEach((group) => {
    let matches
    switch (group.name) {
      case '基本参数':
        group.fields.forEach((field) => {
          switch (field.name) {
            case '级别':
              car.carType = getCarTypeKey(enumValues, field.value)
              break
            case '发动机':
              matches = field.value.match(/^(\d+\.?\d*)\s*(L|T).*$/i)
              if (matches) {
                car.displacement = parseFloat(matches[1]).toFixed(1)
                car.isTurboCharger = matches[2].toUpperCase() === 'T'
              }
              break
            case '变速箱':
              matches = field.value.match(/^\d+挡(.*)$/)
              if (matches) {
                car.transmission = getTransmissionKey(enumValues, matches[1])
              } else {
                car.transmission = getTransmissionKey(enumValues, field.value)
              }
              break
            case '车身结构':
              matches = field.value.match(/^(\d+).*$/)
              if (matches) {
                car.doorCount = +matches[1]
              }
              break
            default:
              break
          }
        })
        break
      case '发动机':
        group.fields.forEach((field) => {
          switch (field.name) {
            case '环保标准':
              matches = field.value.match(/^([^\),\(,]+).*$/)
              if (matches) {
                const emissionStandardKey = getEmissionStandardKey(enumValues, matches[1])
                if (emissionStandardKey) {
                  car.emissionStandard = emissionStandardKey
                }
              }
              break
            case '燃料形式':
              car.fuelType = getFuelTypeKey(enumValues, field.value)
              break
            default:
              break
          }
        })
        break
      default:
        break
    }
  })
  return car
}

export default (state, action) => {
  switch (action.type) {
    case DETAIL_FETCH_SUCCESS: {
      const features = action.response.carConfiguration
      features.forEach((group) => {
        group.fields.forEach((field) => {
          if (field.type === 'select') {
            field.present = field.value === '标配'
          } else {
            field.present = !!field.value
          }
        })
      })
      return {
        ...state,
        car: {
          ...state.car,
          manufacturerConfiguration: {
            ...state.car.manufacturerConfiguration,
            value: features,
          },
        },
      }
    }
    case actionTypes.CHANGE: {
      if (action.form !== 'car') {
        return state
      }
      const fields = [
        'car.newCarDiscount',
        'car.newCarGuidePriceWan',
        'car.newCarAdditionalPriceWan',
      ]
      if (fields.includes(action.field)) {
        return {
          ...state,
          car: {
            ...state.car,
            newCarFinalPriceWan: {
              ...state.car.newCarFinalPriceWan,
              value: computeNewCarFinalPrice(
                state.car.newCarDiscount && state.car.newCarDiscount.value,
                state.car.newCarGuidePriceWan && state.car.newCarGuidePriceWan.value,
                state.car.newCarAdditionalPriceWan && state.car.newCarAdditionalPriceWan.value
              ),
            },
          },
        }
      }
      if (['car.seriesName', 'car.styleName', 'car.brandName'].includes(action.field)) {
        return {
          ...state,
          car: {
            ...state.car,
            name: {
              ...state.car.name,
              value: [
                state.car.brandName.value,
                state.car.seriesName.value,
                state.car.styleName.value,
              ].join(' ').trim(),
            },
          },
        }
      }
      if (action.field === 'car.mileage'
          && !state.car.mileageInFact.initial
          && !state.car.mileageInFact.touched) {
        return {
          ...state,
          car: {
            ...state.car,
            mileageInFact: {
              ...state.car.mileageInFact,
              value: state.car.mileage.value,
            },
          },
        }
      }
      if (action.field === 'car.showPriceWan'
          && !state.car.onlinePriceWan.initial
          && !state.car.onlinePriceWan.touched) {
        return {
          ...state,
          car: {
            ...state.car,
            onlinePriceWan: {
              ...state.car.onlinePriceWan,
              value: state.car.showPriceWan.value,
            },
          },
        }
      }
      if (action.field === 'car.salesMinimunPriceWan'
          && !state.car.managerPriceWan.initial
          && !state.car.managerPriceWan.touched) {
        return {
          ...state,
          car: {
            ...state.car,
            managerPriceWan: {
              ...state.car.managerPriceWan,
              value: state.car.salesMinimunPriceWan.value,
            },
            allianceMinimunPriceWan: {
              ...state.car.allianceMinimunPriceWan,
              value: state.car.salesMinimunPriceWan.value,
            },
          },
        }
      }
      if (action.field === 'car.managerPriceWan'
          && !state.car.allianceMinimunPriceWan.initial
          && !state.car.allianceMinimunPriceWan.touched) {
        return {
          ...state,
          car: {
            ...state.car,
            allianceMinimunPriceWan: {
              ...state.car.allianceMinimunPriceWan,
              value: state.car.managerPriceWan.value,
            },
          },
        }
      }
      return state
    }
    case SYNC_FEATURES:
      return {
        ...state,
        car: {
          ...state.car,
          configurationNote: {
            ...state.car.configurationNote,
            value: action.note,
          },
        },
      }
    case APPLY_STYLE_DETAIL: {
      const nextCar = Object.keys(action.car).reduce((accumulator, key) => ({
        ...accumulator,
        [key]: {
          ...accumulator[key],
          value: action.car[key],
        },
      }), state.car)
      return {
        ...state,
        car: {
          ...nextCar,
          newCarFinalPriceWan: {
            ...nextCar.newCarFinalPriceWan,
            value: computeNewCarFinalPrice(
              nextCar.newCarDiscount && nextCar.newCarDiscount.value,
              nextCar.newCarGuidePriceWan && nextCar.newCarGuidePriceWan.value,
              nextCar.newCarAdditionalPriceWan && nextCar.newCarAdditionalPriceWan.value
            ),
          },
        },
      }
    }
    case AUTO_FILL_EXPIRATION_DATES: {
      const nextExpiration = Object.keys(action.expiration).reduce((accumulator, key) => ({
        ...accumulator,
        [key]: {
          ...accumulator[key],
          value: action.expiration[key],
        },
      }), state.acquisitionTransfer || {})
      return {
        ...state,
        acquisitionTransfer: {
          ...nextExpiration,
        },
      }
    }
    case CREATE_FAILURE:
    case UPDATE_FAILURE:
      return {
        ...state,
        ...{ car: { ...state.car, ...(mapValues(action.error.errors.car, (errors, field) => ({
          ...state.car[field],
          submitError: errors[0],
        }))) } },
        _error: action.error.errors.car,
        _submitting: false,
      }
    default:
      return state
  }
}

export function syncFeatures(note) {
  return {
    type: SYNC_FEATURES,
    note,
  }
}

export function applyStyleDetail(enumValues, features, recommendedPrice) {
  return {
    type: APPLY_STYLE_DETAIL,
    car: extractCarFields(enumValues, features, recommendedPrice),
  }
}

export function autoFillExpirationDates(licensedAt) {
  return {
    type: AUTO_FILL_EXPIRATION_DATES,
    expiration: computeExpirationDates(licensedAt),
  }
}
