import { createValidator, required } from 'utils/validation'

export default createValidator({
  name: [required],
  message: [(value, data) => {
    if (data.cate === 'msg' && !value) {
      return '不能为空'
    }
  }],
  url: [(value, data) => {
    if (data.cate === 'url' && !value) {
      return '不能为空'
    }
  }],
})
