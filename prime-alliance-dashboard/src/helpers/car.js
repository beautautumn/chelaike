import date from './date'
import config from 'config'
import formData from 'form-data-to-object'
import toPairs from 'lodash/toPairs'
import { decamelizeKeys } from 'humps'

export function licensedInfoText(car) {
  switch (car.licenseInfo) {
    case 'unlicensed':
      return '未上牌'
    case 'new_car':
      return '新车'
    case 'licensed':
      return date(car.licensedAt, 'short')
    default:
      return ''
  }
}

export function displacement(car) {
  if (!car.displacement) {
    return ''
  }
  if (car.isTurboCharger) {
    return `${car.displacement}T`
  }
  return `${car.displacement}L`
}

export function price(value, unit = '', placeholder = true) {
  if (value) {
    return value + unit
  }
  return placeholder ? '待定价' : ''
}

export function acquisitionPriceText(car) {
  switch (car.acquisitionType) {
    case 'consignment':
      return ['寄卖价', price(car.consignorPriceWan, '万', false)]
    case 'cooperation':
      return ['合作总价', price(car.acquisitionPriceWan, '万', false)]
    default:
      return ['收购价', price(car.acquisitionPriceWan, '万', false)]
  }
}

export function featureText(value) {
  switch (value) {
    case '标配':
      return '● 厂家配置'
    case '选配':
      return '○ 车主加装'
    case '无':
      return '- 无'
    default:
      return value
  }
}

export function transferRecordEstimatedTime(transferRecord) {
  if (!transferRecord) {
    return null
  }
  if (!transferRecord.state || transferRecord.state === 'archiving') {
    return transferRecord.estimatedArchivedAt
  }
  if (transferRecord.state === 'transfering' ||
      transferRecord.state === 'finished') {
    return transferRecord.estimatedTransferredAt
  }
  return null
}

export function licensePresentText(acquisitionTransfer, license) {
  return acquisitionTransfer.items.includes(license) ? '有' : '无'
}

export function exportLink(query, currentUser, type) {
  const queryArray =
    toPairs(formData.fromObj({ query: decamelizeKeys(query) })).map((field) => field.join('='))
  queryArray.push(`AutobotsToken=${currentUser.token}`)
  queryArray.push(`report_type=${type}`)
  const queryString = queryArray.join('&')
  return `${config.serverUrl}/api/v1/alliance_dashboard/reports/new?${queryString}`
}

export function computeWarningLevel(car) {
  if (car.stockAgeDays >= car.yellowStockWarningDays &&
      car.stockAgeDays < car.redStockWarningDays) {
    return 'yellow'
  } else if (car.stockAgeDays >= car.redStockWarningDays) {
    return 'red'
  }
  return null
}
