import { createValidator, required, phoneNumber } from 'utils/validation'

export default createValidator({
  completedAt: [required],
  sellerId: [required],
  customerChannelId: [required],
  salesType: [required],
  paymentType: [required],
  customerPhone: [required, phoneNumber],
  closingCostWan: [required],
})
