import { createValidator, required } from 'utils/validation'

export default createValidator({
  name: [required],
  timeLimitation: [required]
})
