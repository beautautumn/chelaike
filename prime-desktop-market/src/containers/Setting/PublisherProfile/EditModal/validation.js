import { createValidator, required } from 'utils/validation'

const profileValidator = createValidator({
  username: [required],
  password: [required],
  defaultDescription: [required],
})

export default (data) => {
  const errors = {}

  errors.data = profileValidator(data.data)

  return errors
}
