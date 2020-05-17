import React, { PropTypes } from 'react'
import { Col, Input, Checkbox } from 'antd'
import { FormItem } from 'components'

function isReadOnly(groupName) {
  return ['基本参数', '车身', '发动机', '变速箱'].includes(groupName)
}

export default function Field({ groupName, field, fieldPath, onChange }) {
  const presentFieldPath = `${fieldPath}.present`

  if (isReadOnly(groupName)) {
    return (
      <Col span="8">
        <FormItem labelCol={{ span: 8 }} wrapperCol={{ span: 16 }} label={`${field.name}：`}>
          <Input disabled value={field.value} />
        </FormItem>
      </Col>
    )
  }

  return (
    <Col span="4" offset="1">
      <FormItem>
        <label>
          <Checkbox
            checked={field.present}
            onChange={event => onChange(presentFieldPath, event.target.checked)}
          />
          {field.name}
        </label>
      </FormItem>
    </Col>
  )
}

Field.propTypes = {
  groupName: PropTypes.string.isRequired,
  field: PropTypes.object.isRequired,
  fieldPath: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired,
}
