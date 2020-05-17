export default (data) => {
  const errors = {}

  if (!data.name) {
    errors.name = '合作商家名称不能为空'
  }
  if (!data.shopId) {
    errors.shopId = '归属分店不能为空'
  }

  return errors
}
