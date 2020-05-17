import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import { Field, NumberInput } from 'components'
import { autoId } from 'decorators'
import validation from './validation'

@reduxForm({
  form: 'warranty',
  fields: ['id', 'name', 'fee', 'note'],
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
          <label htmlFor={autoId()}>质保等级名称</label>
          <input id={autoId()} type="text" {...fields.name} />
        </Field>
        <div className="field">
          <label htmlFor={autoId()}>质保费用</label>
          <NumberInput id={autoId()} {...fields.fee} />
        </div>
        <div className="field">
          <label htmlFor={autoId()}>备注</label>
          <Textarea rows={2} id={autoId()} {...fields.note} />
        </div>
      </div>
    )
  }
}
