import { phoneNumber } from 'utils/validation'

export default (data) => {
  const errors = {
    company: {},
    user: {},
  }

  if (!data.company.name) {
    errors.company.name = '公司名称不能为空！'
  }

  if (!data.company.marketArea) {
    errors.company.marketArea = '市场面积不能为空！'
  }

  if (!data.company.contact) {
    errors.company.contact = '公司联系人不能为空！'
  }

  if (!data.company.province) {
    errors.company.province = '公司所在省份不能为空！'
  }

  if (!data.company.city) {
    errors.company.city = '公司所在城市不能为空！'
  }

  if (!data.user.phone) {
    errors.user.phone = '手机号不能为空！'
  } else {
    errors.user.phone = phoneNumber(data.user.phone)
  }

  if (!data.user.password) {
    errors.user.password = '密码不能为空！'
  }

  if (data.user.password && data.user.password.length < 6) {
    errors.user.password = '密码不能少于6位！'
  }

  if (data.user.confirmPassword !== data.user.password) {
    errors.user.confirmPassword = '两次输入的密码不一致！'
  }

  return errors
}
