import { createValidator } from 'utils/validation'

export default createValidator({
  carFees: [(value) => {
    if (!value || value.length === 0) {
      return '尚未添加任何费用'
    }
  }]
})
