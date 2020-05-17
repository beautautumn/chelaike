import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { FormItem } from 'components'
import { errorFocus } from 'decorators'
import validation from './validation'
import { Form as AntdForm, Input } from 'antd'

@reduxForm({
  form: 'passwordChange',
  fields: ['originalPassword', 'password', 'confirmPassword'],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
  }

  render() {
    const { fields } = this.props
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 14 },
    }

    return (
      <AntdForm horizontal>
        <FormItem {...formItemLayout} required field={fields.originalPassword} label="原密码：">
          <Input type="password" {...fields.originalPassword} placeholder="请输入原密码" />
        </FormItem>
        <FormItem {...formItemLayout} required field={fields.password} label="新密码：">
          <Input type="password" {...fields.password} placeholder="请输入新密码" />
        </FormItem>
        <FormItem {...formItemLayout} required field={fields.confirmPassword} label="确认新密码：">
          <Input type="password" {...fields.confirmPassword} placeholder="请重输入复新密码" />
        </FormItem>
      </AntdForm>
    )
  }
}
