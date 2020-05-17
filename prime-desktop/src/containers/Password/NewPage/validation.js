export default (data) => {
  const errors = {}

  if (!data.password) {
    errors.password = '请输入新密码！'
  }

  if (data.password && data.password.length < 6) {
    errors.password = '密码长度应大于等于6位！'
  }

  if (!data.confirmPassword || data.confirmPassword !== data.password) {
    errors.confirmPassword = '请确认新密码！'
  }

  return errors
}
