export default (data) => {
  const errors = {}

  if (!data.name) {
    errors.name = '质保等级名称不能为空'
  }

  return errors
}
