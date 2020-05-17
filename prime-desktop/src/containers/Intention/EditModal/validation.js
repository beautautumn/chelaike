import { createValidator, required, phoneNumber } from 'utils/validation'

export default createValidator({
  customerPhone: [required, phoneNumber],
  channelId: [required]
})
