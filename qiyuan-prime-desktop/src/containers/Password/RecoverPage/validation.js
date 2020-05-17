import { phoneNumber } from 'utils/validation'

export default (data) => {
  const errors = {}

  if (!data.phone) {
    errors.phone = '请输入手机号码！'
  } else {
    errors.phone = phoneNumber(data.phone)
  }

  if (!data.code) {
    errors.code = '请先获取验证码！'
  }

  return errors
}
