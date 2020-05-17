import { createValidator, required } from 'utils/validation'

export default createValidator({
  fundRate: [required],
  gearing: [required],
  rent: [required],
  area: [(value, data) => {
    if (!value) return '不允许为空'
    if (isNaN(value)) return '必须为数字'
    if (data.rentBy === 'unit' && parseInt(value, 10) != value) return '车位数不允许带小数' // eslint-disable-line
  }],
})
