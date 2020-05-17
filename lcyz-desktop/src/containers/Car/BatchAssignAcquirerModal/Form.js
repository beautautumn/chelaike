import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { reduxForm } from 'redux-form'
import { FormItem, UserSelect } from 'components'
import { errorFocus } from 'decorators'
import { Form as AntdForm } from 'antd'
import validate from './validation'

@reduxForm({
  form: 'batchAssignAcquirer',
  fields: ['acquirer'],
  validate
})
@errorFocus
export default class Form extends PureComponent {
  static propTypes = {
    fields: PropTypes.object.isRequired,
  }

  render() {
    const { fields } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 }
    }

    return (
      <AntdForm horizontal>
        <FormItem required field={fields.acquirer} {...formItemLayout} label="车源负责人：">
          <UserSelect {...fields.acquirer} as="all" />
        </FormItem>
      </AntdForm>
    )
  }
}
