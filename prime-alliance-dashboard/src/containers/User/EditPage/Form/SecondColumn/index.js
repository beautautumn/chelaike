import React, { PropTypes } from 'react'
import { FormItem, RadioGroup, MultiRoleSelect } from 'components'
import { Col, Radio } from 'antd'

export default function SecondColumn({ fields, roles, handleRoleChange }) {
  const formItemLayout = {
    labelCol: { span: 8 },
    wrapperCol: { span: 16 },
  }

  return (
    <Col span="12">
      <FormItem {...formItemLayout} label="权限类型：">
        <RadioGroup {...fields.authorityType}>
          <Radio key="role" value="role">关联角色</Radio>
          <Radio key="custom" value="custom">单独设置</Radio>
        </RadioGroup>
      </FormItem>

      {fields.authorityType.value === 'role' &&
        <FormItem {...formItemLayout} label="关联角色：">
          <MultiRoleSelect roles={roles} {...fields.authorityRoleIds} onChange={handleRoleChange} />
        </FormItem>
      }

      <FormItem {...formItemLayout} label="启用状态：">
        <RadioGroup {...fields.state}>
          <Radio key="enabled" value="enabled">启用</Radio>
          <Radio key="disabled" value="disabled">禁用</Radio>
        </RadioGroup>
      </FormItem>
    </Col>
  )
}

SecondColumn.propTypes = {
  roles: PropTypes.array,
  fields: PropTypes.object.isRequired,
  handleRoleChange: PropTypes.func.isRequired,
}
