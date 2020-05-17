import React, { PropTypes } from 'react'
import { compose } from 'redux'
import { reduxForm } from 'redux-form'
import { autoId } from 'decorators'
import { Form as AForm, Input } from 'antd'
import { FormItem } from 'components'
import validation from './validation'

function Form({ fields, autoId }) {
  const formItemLayout = {
    labelCol: { span: 4 },
    wrapperCol: { span: 18 },
  }

  return (
    <AForm horizontal>
      <FormItem {...formItemLayout} id={autoId()} required label="渠道名称：" field={fields.name}>
        <Input id={autoId()} type="text" {...fields.name} />
      </FormItem>
      <FormItem {...formItemLayout} id={autoId()} label="备注：">
        <Input id={autoId()} type="textarea" autosize rows={2} {...fields.note} />
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
    fields: ['id', 'name', 'note'],
    validate: validation,
  }),
  autoId
)(Form)
