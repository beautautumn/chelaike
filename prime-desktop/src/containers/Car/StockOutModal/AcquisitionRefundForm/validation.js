import { createValidator, required, ltTenThousand } from 'utils/validation'

export default createValidator({
  refundedAt: [required],
  refundPriceWan: [ltTenThousand] })
