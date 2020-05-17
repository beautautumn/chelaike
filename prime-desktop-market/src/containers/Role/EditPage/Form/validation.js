export default (data) => {
  const errors = {}

  if (!data.name) {
    errors.name = '角色名称不能为空'
  }

  return errors
}
