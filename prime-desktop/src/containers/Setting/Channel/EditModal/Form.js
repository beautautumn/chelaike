import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import { Field } from 'components'
import { autoId } from 'decorators'
import validation from './validation'

@reduxForm({
  form: 'channel',
  fields: ['id', 'name', 'note'],
  validate: validation
})
@autoId
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    autoId: PropTypes.func.isRequired
  }

  render() {
    const { fields, autoId } = this.props

    return (
      <div className="ui form">
        <Field className="required field" {...fields.name}>
          <label htmlFor={autoId()}>渠道名称</label>
          <input id={autoId()} type="text" {...fields.name} />
        </Field>
        <div className="field">
          <label htmlFor={autoId()}>备注</label>
          <Textarea id={autoId()} rows={2} {...fields.note} />
        </div>
      </div>
    )
  }
}
