import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { FormItem, UserSelect } from 'components'
import { Form as AForm } from 'antd'

@reduxForm({
  form: 'intentionShare',
  fields: ['sharedUsers'],
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    intention: PropTypes.object.isRequired,
  }

  render() {
    const { fields, intention } = this.props

    const intentionInfo = (intention.customerName || intention.customerPhone) +
      '的' + (intention.intentionType === 'sale' ? '出售' : '求购')

    const userHaveRole = intention.intentionType === 'sale' ? 'acquirer' : 'seller'

    return (
      <AForm>
        <FormItem field={fields.sharedUsers} label={`将客户“${intentionInfo}”意向分享给`}>
          <UserSelect multiple {...fields.sharedUsers} as={userHaveRole} />
        </FormItem>
      </AForm>
    )
  }
}
