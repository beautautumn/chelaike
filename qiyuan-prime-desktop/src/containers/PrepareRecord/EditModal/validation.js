import { createValidator, required } from 'utils/validation'

export default createValidator({
  state: [required],
  preparerId: [required]
})
