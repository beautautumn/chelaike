import { createValidator, required, phoneNumber } from 'utils/validation'
import can from 'helpers/can'

const carValidator = createValidator({
  shopId: [required],
  name: [required],
  acquirerId: [(value) => {
    if (can('收购信息查看') && !value) {
      return '不能为空'
    }
  }],
  acquiredAt: [(value) => {
    if (can('收购信息查看') && !value) {
      return '不能为空'
    }
  }],
  brandName: [required],
  seriesName: [required],
  mileage: [required],
  acquisitionType: [(value) => {
    if (can('收购信息查看') && !value) {
      return '不能为空'
    }
  }],
  consignorName: [(value, data) => {
    if (data.acquisitionType === 'consignment' && !value) {
      return '不能为空'
    }
  }],
  consignorPhone: [(value, data) => {
    if (data.acquisitionType === 'consignment' && !value) {
      return '不能为空'
    }
    if (data.acquisitionType === 'consignment') {
      return phoneNumber(value)
    }
  }],
  licensedAt: [(value, data) => {
    if (data.licenseInfo === 'licensed' && !value) {
      return '不能为空'
    }
  }],
  acquisitionPriceWan: [(value, data) => {
    if (data.acquisitionType !== 'consignment') {
      if (!data.id || (can('收购信息查看') && can('收购价格查看'))) {
        if (!value) return '不能为空'
      }
    }
  }],
})

const che168Validator = createValidator({
  sellerId: [(value, data) => {
    if (data.syncable && !value) {
      return '不能为空'
    }
  }]
})

const acquisitionTransferValidator = createValidator({
  keyCount: [(...args) => {
    if (can('牌证信息录入')) {
      return required(...args)
    }
  }],
})

export default function validation(data) {
  const errors = { car: {}, publishers: {} }

  errors.car = carValidator(data.car)

  errors.publishers.che168 = che168Validator(data.publishers.che168)

  errors.acquisitionTransfer = acquisitionTransferValidator(data.acquisitionTransfer)

  return errors
}
