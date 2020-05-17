import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Field, NumberInput } from 'components'
import validation from './validation'

@reduxForm({
  form: 'guestReminder',
  fields: ['firstNotify', 'secondNotify', 'thirdNotify'],
  validate: validation
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired
  }

  render() {
    const { fields } = this.props

    return (
      <div className="ui form">
        <Field className="required field" {...fields.firstNotify}>
          <label htmlFor="first">首次提醒</label>
          <div className="ui right labeled input">
            <div className="ui label">提前</div>
            <NumberInput id="first" {...fields.firstNotify} />
            <div className="ui basic label">天提醒</div>
          </div>
        </Field>
        <Field className="required field" {...fields.secondNotify}>
          <label htmlFor="first">再次提醒</label>
          <div className="ui right labeled input">
            <div className="ui label">提前</div>
            <NumberInput id="first" {...fields.secondNotify} />
            <div className="ui basic label">天提醒</div>
          </div>
        </Field>
        <Field className="required field" {...fields.thirdNotify}>
          <label htmlFor="first">三次提醒</label>
          <div className="ui right labeled input">
            <div className="ui label">提前</div>
            <NumberInput id="first" {...fields.thirdNotify} />
            <div className="ui basic label">天提醒</div>
          </div>
        </Field>
      </div>
    )
  }
}
