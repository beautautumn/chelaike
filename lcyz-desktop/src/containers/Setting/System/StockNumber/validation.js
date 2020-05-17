export default (data) => {
  const errors = {}

  if (data.automatedStockNumber && !data.automatedStockNumberPrefix) {
    errors.automatedStockNumberPrefix = '库存号前缀不能为空！'
  }

  return errors
}
