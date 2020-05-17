import { createValidator, phoneNumber } from 'utils/validation'

export default createValidator({
  contactMobile: [phoneNumber],
  newOwnerContactMobile: [phoneNumber],
})
