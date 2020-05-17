export default (data) => {
  const errors = {}

  if (!data.name) {
    errors.name = '战败原因名称不能为空'
  }

  return errors
}
