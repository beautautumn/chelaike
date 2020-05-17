export default (data) => {
  const errors = {}

  if (!data.name) {
    errors.name = '渠道名称不能为空'
  }

  return errors
}
