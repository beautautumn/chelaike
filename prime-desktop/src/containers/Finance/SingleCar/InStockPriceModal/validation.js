import { createValidator, required } from 'utils/validation'

export default createValidator({
  shopId: [required],
  acquirerId: [required],
  acquiredAt: [required],
  acquisitionPriceWan: [required],
})
