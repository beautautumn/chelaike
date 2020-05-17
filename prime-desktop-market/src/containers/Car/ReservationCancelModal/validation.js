import { createValidator, required, ltTenThousand } from 'utils/validation'

export default createValidator({
  canceledAt: [required],
  cancelablePriceWan: [required, ltTenThousand]
})
