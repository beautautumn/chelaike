import React, { PropTypes } from 'react'
import { Form } from 'antd'

/**
 * 废掉 Form.Item 的 shouldComponentUpdate，因为我们在 BrandSelectGroup
 * 这样的及联选框里用了 context，Form.Item 的 shouldComponentUpdate 没有处理
 * context，导致 context 变化的时候 Form.Item 不重新 render
 */
Form.Item.prototype.shouldComponentUpdate = () => true

export default function FormItem({ children, field = {}, ...passedProps }) {
  const fields = Array.isArray(field) ? field : [field]

  let validateStatus
  let help

  if (fields.some((field) => field.touched && !field.valid)) {
    validateStatus = 'error'
    help = field.error
  }

  return (
    <Form.Item {...passedProps} validateStatus={validateStatus} help={help}>
      {children}
    </Form.Item>
  )
}

FormItem.propTypes = {
  children: PropTypes.oneOfType([PropTypes.array, PropTypes.element]),
  field: PropTypes.oneOfType([PropTypes.object, PropTypes.array]),
}
