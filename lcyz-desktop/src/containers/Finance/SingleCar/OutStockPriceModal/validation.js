import { createValidator, required } from 'utils/validation'

export default createValidator({
  sellerId: [required],
  completedAt: [required],
  closingCostWan: [required],
})
