import React, { PropTypes } from 'react'
import { FormItem, Select } from 'components'
import { Input, Col } from 'antd'

export default function FirstColumn({ fields }) {
  let passwordPlaceholder = '最短6位，区分大小写'
  if (fields.id.value) {
    passwordPlaceholder += '，如果不需要修改密码，请不要填写'
  }

  const formItemLayout = {
    labelCol: { span: 6 },
    wrapperCol: { span: 18 },
  }

  return (
    <Col span="12">
      {/* 防止360浏览自动填写 */}
      <input type="text" style={{ display: 'none' }} />
      <input type="password" style={{ display: 'none' }} />

      <FormItem
        {...formItemLayout}
        required
        label="姓名："
        field={fields.name}
      >
        <Input type="text" {...fields.name} />
      </FormItem>

      <FormItem
        {...formItemLayout}
        required
        label="用户名："
        field={fields.username}
      >
        <Input
          autoComplete="off"
          type="text"
          placeholder="设置后可用于登陆"
          {...fields.username}
        />
      </FormItem>

      <FormItem
        {...formItemLayout}
        required={!fields.id.value}
        label="密码："
        field={fields.password}
      >
        <Input
          autoComplete="off"
          type="password"
          placeholder={passwordPlaceholder}
          {...fields.password}
        />
      </FormItem>

      <FormItem
        {...formItemLayout}
        required={!fields.id.value}
        label="确认密码："
        field={fields.passwordConfirmation}
      >
        <Input
          autoComplete="off"
          type="password"
          {...fields.passwordConfirmation}
        />
      </FormItem>

      <FormItem
        {...formItemLayout}
        required
        label="手机号码："
        field={fields.phone}
      >
        <Input type="text" {...fields.phone} />
      </FormItem>

      <FormItem {...formItemLayout} label="邮箱：">
        <Input type="email" {...fields.email} />
      </FormItem>

      <FormItem {...formItemLayout} label="所属经理：">
        <Select.User {...fields.managerId} />
      </FormItem>

      <FormItem {...formItemLayout} label="员工描述：">
        <Input type="textarea" autosize rows={4} {...fields.note} />
      </FormItem>
    </Col>
  )
}


FirstColumn.propTypes = {
  fields: PropTypes.object.isRequired,
}
