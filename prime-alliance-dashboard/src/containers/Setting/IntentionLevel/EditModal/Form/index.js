import React, { PropTypes } from 'react'
import { compose } from 'redux'
import { reduxForm } from 'redux-form'
import { autoId } from 'decorators'
import { Form as AForm, Input, InputNumber } from 'antd'
import { FormItem } from 'components'
import validation from './validation'

function Form({ fields, autoId }) {
  const formItemLayout = {
    labelCol: { span: 8 },
    wrapperCol: { span: 14 },
  }

  return (
    <AForm horizontal>
      <FormItem {...formItemLayout} id={autoId()} required label="客户等级：" field={fields.name}>
        <Input id={autoId()} type="text" {...fields.name} />
      </FormItem>
      <FormItem {...formItemLayout} id={autoId()} label="最大跟进间隔天数备注：">
        <InputNumber id={autoId()} {...fields.timeLimitation} />
      </FormItem>
    </AForm>
  )
}

Form.propTypes = {
  fields: PropTypes.object.isRequired,
  autoId: PropTypes.func.isRequired,
}

export default compose(
  reduxForm({
    form: 'channel',
    fields: ['id', 'name', 'timeLimitation'],
    validate: validation,
  }),
  autoId
)(Form)
