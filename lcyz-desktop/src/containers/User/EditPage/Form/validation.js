import { phoneNumber } from 'utils/validation'
import isEmpty from 'lodash/isEmpty'
import compact from 'lodash/compact'

export default (data) => {
  const errors = {}

  if (!data.name) {
    errors.name = '姓名不能为空'
  }
  if (!data.username) {
    errors.username = '用户名不能为空'
  }
  if (!data.id) {
    if (!data.password) {
      errors.password = '密码不能为空'
    }
    if (data.password && data.password.length < 6) {
      errors.password = '密码不能少于6位'
    }
  }
  if (data.password && data.password !== data.passwordConfirmation) {
    errors.passwordConfirmation = '两次密码不匹配'
  }
  if (!data.phone) {
    errors.phone = '手机号码不能为空'
  } else {
    errors.phone = phoneNumber(data.phone)
  }
  if (!data.shopId) {
    errors.shopId = '所属分店不能为空'
  }

  if (data.settings.macAddressLock && !data.macAddress) {
    errors.macAddress = 'MAC地址不能为空'
  }

  if (data.settings.deviceNumberLock && isEmpty(compact(data.deviceNumbers))) {
    errors.deviceNumbers = '设备号不能为空'
  }

  return errors
}
