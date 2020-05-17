export default (data) => {
  const errors = {}

  if (!data.state) {
    errors.state = '车辆状态不能为空'
  }

  if (!data.occurredAt) {
    errors.occurredAt = '发生时间不能为空'
  }

  return errors
}
