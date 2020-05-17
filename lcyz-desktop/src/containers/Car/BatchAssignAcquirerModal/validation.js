import { createValidator, required } from 'utils/validation'

export default createValidator({
  acquirer: [required],
})

