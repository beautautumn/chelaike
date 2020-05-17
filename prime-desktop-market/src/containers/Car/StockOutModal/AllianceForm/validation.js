import { createValidator, required } from 'utils/validation'

export default createValidator({
  closingCostWan: [required],
  depositWan: [required],
  remainingMoneyWan: [required],
  allianceId: [required],
  companyId: [required],
  sellerId: [required],
  completedAt: [required],
})
