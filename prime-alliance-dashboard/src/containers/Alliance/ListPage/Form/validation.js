export default function (values) {
  const errors = {}
  if (!values.name) {
    errors.name = '不能为空'
  }

  if (values.waterMark) {
    errors.waterMarkPosition = {}
    if (!values.waterMarkPosition.p) {
      errors.waterMarkPosition.p = '不能为空'
    }
    if (!values.waterMarkPosition.x) {
      errors.waterMarkPosition.x = '不能为空'
    }
    if (!values.waterMarkPosition.y) {
      errors.waterMarkPosition.y = '不能为空'
    }
  }
  return errors
}
