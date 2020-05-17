import { createValidator, required, ltTenThousand } from 'utils/validation'
import can from 'helpers/can'

const carValidator = createValidator({
  companyId: [required],
  name: [required],
  acquirerId: [(value) => {
    let error
    if (can('收购信息查看') && !value) {
      error = '不能为空'
    }
    return error
  }],
  acquiredAt: [(value) => {
    let error
    if (can('收购信息查看') && !value) {
      error = '不能为空'
    }
    return error
  }],
  brandName: [required],
  seriesName: [required],
  mileage: [required],
  acquisitionType: [(value) => {
    let error
    if (can('收购信息查看') && !value) {
      error = '不能为空'
    }
    return error
  }],
  consignorName: [(value, data) => {
    let error
    if (data.acquisitionType === 'consignment' && !value) {
      error = '不能为空'
    }
    return error
  }],
  consignorPhone: [(value, data) => {
    let error
    if (data.acquisitionType === 'consignment' && !value) {
      error = '不能为空'
    }
    return error
  }],
  licensedAt: [(value, data) => {
    let error
    if (data.licenseInfo === 'licensed' && !value) {
      error = '不能为空'
    }
    return error
  }],
  acquisitionPriceWan: [(value, data) => {
    let error
    if (data.acquisitionType !== 'consignment') {
      error = ltTenThousand(value)
    }
    return error
  }],
  consignorPriceWan: [(value, data) => {
    let error
    if (data.acquisitionType === 'consignment') {
      error = ltTenThousand(value)
    }
    return error
  }],
  showPriceWan: [ltTenThousand],
  onlinePriceWan: [ltTenThousand],
  salesMinimunPriceWan: [ltTenThousand],
  managerPriceWan: [ltTenThousand],
  allianceMinimunPriceWan: [ltTenThousand],
  newCarGuidePriceWan: [ltTenThousand],
  newCarAdditionalPriceWan: [ltTenThousand],
  newCarFinalPriceWan: [ltTenThousand],
})

export default function validation(data) {
  const errors = { car: {}, publishers: {} }

  errors.car = carValidator(data.car)

  return errors
}
