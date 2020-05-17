export default (data) => {
  const errors = {}

  if (!data.name) {
    errors.name = '保险公司名称不能为空'
  }

  return errors
}
