import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Select, Datepicker, FormItem } from 'components'
import { errorFocus } from 'decorators'
import validation from './validation'
import { Form as AForm } from 'antd'

@reduxForm({
  form: 'intentionAssign',
  fields: ['assigneeId', 'processingTime'],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    checkedIds: PropTypes.array.isRequired,
    users: PropTypes.array.isRequired
  }

  render() {
    const { fields, checkedIds, users } = this.props

    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 14 },
    }
    return (
      <AForm horizontal>
        <FormItem
          {...formItemLayout}
          label={`将这${checkedIds.length}条意向分配给：`}
          required
          field={fields.assigneeId}
        >
          <Select items={users} {...fields.assigneeId} />
        </FormItem>
        <FormItem {...formItemLayout} label="下次跟进：">
          <Datepicker {...fields.processingTime} />
        </FormItem>
      </AForm>
    )
  }
}
