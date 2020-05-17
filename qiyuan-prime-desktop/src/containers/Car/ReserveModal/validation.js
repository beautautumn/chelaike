import { createValidator, required, phoneNumber } from 'utils/validation'

export default createValidator({
  customerChannelId: [required],
  reservedAt: [required],
  depositWan: [required],
  customerName: [required],
  customerPhone: [required, phoneNumber]
})
