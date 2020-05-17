import { createValidator, required } from 'utils/validation'

export default createValidator({
  state: [required],
  note: [required],
  processingTime: [(value, data) => {
    if (['failed', 'invalid', 'processing'].includes(data.state) && !value) {
      return '不能为空'
    }
    return null
  }],
  interviewedTime: [(value, data) => {
    if (data.state === 'interviewed' && !value) {
      return '不能为空'
    }
    return null
  }],
})
