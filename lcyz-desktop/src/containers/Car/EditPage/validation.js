import { createValidator, required } from 'utils/validation'
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
  licensedAt: [(value, data) => {
    if (data.licenseInfo === 'licensed' && !value) {
      return '不能为空'
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

// const acquisitionTransferValidator = createValidator({
//   keyCount: [(...args) => {
//     if (can('牌证信息录入')) {
//       return required(...args)
//     }
//   }],
// })

export default function validation(data) {
  const errors = { car: {}, publishers: {} }

  errors.car = carValidator(data.car)

  errors.publishers.che168 = che168Validator(data.publishers.che168)

  // errors.acquisitionTransfer = acquisitionTransferValidator(data.acquisitionTransfer)

  return errors
}
