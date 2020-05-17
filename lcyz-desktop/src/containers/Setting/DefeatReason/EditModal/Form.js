import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Field } from 'components'
import validation from './validation'

@reduxForm({
  form: 'defeatReason',
  fields: ['id', 'name', 'note'],
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
        <Field className="required field" {...fields.name}>
          <label htmlFor="name">名称</label>
          <input id="name" type="text" {...fields.name} />
        </Field>

        <Field className="field" {...fields.note}>
          <label htmlFor="name">备注</label>
          <input id="note" type="text" {...fields.note} />
        </Field>
      </div>
    )
  }
}
