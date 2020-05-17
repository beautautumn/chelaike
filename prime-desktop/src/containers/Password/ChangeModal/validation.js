export default (data) => {
  const errors = {}

  if (!data.originalPassword) {
    errors.originalPassword = '原始密码不能为空'
  }
  if (!data.password) {
    errors.password = '新密码不能为空'
  }
  if (data.password && data.password.length < 6) {
    errors.password = '密码长度应大于等于6位！'
  }
  if (!data.confirmPassword) {
    errors.confirmPassword = '确认密码不能为空'
  }
  if (data.confirmPassword && data.password !== data.confirmPassword) {
    errors.confirmPassword = '确认密码与新密码不一致'
  }

  return errors
}
