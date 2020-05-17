import React, { PropTypes } from 'react'
import { compose } from 'redux'
import { reduxForm } from 'redux-form'
import { autoId } from 'decorators'
import { Form as AForm, Input } from 'antd'
import { FormItem } from 'components'

function Form({ fields, autoId }) {
  const formItemLayout = {
    labelCol: { span: 4 },
    wrapperCol: { span: 18 },
  }

  return (
    <AForm horizontal>
      <FormItem {...formItemLayout} id={autoId()} label="联盟别称">
        <Input id={autoId()} type="text" {...fields.nickname} />
      </FormItem>
      <FormItem {...formItemLayout} id={autoId()} label="联系人">
        <Input id={autoId()} type="text" {...fields.contact} />
      </FormItem>
      <FormItem {...formItemLayout} id={autoId()} label="联系电话">
        <Input id={autoId()} type="text" {...fields.contactMobile} />
      </FormItem>
      <FormItem {...formItemLayout} id={autoId()} label="看车地址">
        <Input id={autoId()} type="textarea" autosize rows={5} {...fields.street} />
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
    form: 'company',
    fields: ['id', 'name', 'nickname', 'contact', 'contactMobile', 'street'],
  }),
  autoId
)(Form)
