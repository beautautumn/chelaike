import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Field } from 'components'
import Textarea from 'react-textarea-autosize'

@reduxForm({
  form: 'intentionRecoveryTimeEdit',
  fields: ['recoveryTime', 'note'],
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired
  }

  render() {
    const { fields } = this.props

    return (
      <div className="ui form">
        <Field className="field" {...fields.recoveryTime}>
          <label htmlFor="name">过期时间</label>
          <input
            id="name"
            type="number"
            placeholder="未设值则意向过期机制不启用"
            {...fields.recoveryTime}
          />
        </Field>
        <Field className="field" {...fields.note}>
          <label htmlFor="note">备注</label>
          <Textarea rows={2} {...fields.note} />
        </Field>
      </div>
    )
  }
}
