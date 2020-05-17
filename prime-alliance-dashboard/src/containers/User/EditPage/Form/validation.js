import { createValidator, required, minLength } from 'utils/validation'

export default createValidator({
  name: [required],
  username: [required],
  password: [(value, data) => {
    let error = null
    if (!data.id && !data.password) {
      error = '不能为空'
    }
    return error
  }, minLength(6)],
  passwordConfirmation: [(value, data) => {
    let error = null
    if (data.password && data.password !== value) {
      error = '两次密码不匹配'
    }
    return error
  }],
  phone: [required],
})
