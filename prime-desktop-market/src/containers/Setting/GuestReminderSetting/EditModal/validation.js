import { createValidator, required } from 'utils/validation'

export default createValidator({
  firstNotify: [required],
  secondNotify: [required],
  thirdNotify: [required],
})
