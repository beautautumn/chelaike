import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Field } from 'components'
import validation from './validation'

@reduxForm({
  form: 'cooperationCompany',
  fields: ['id', 'name'],
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
          <label htmlFor="name">合作商家名称</label>
          <input id="name" type="text" {...fields.name} />
        </Field>
      </div>
    )
  }
}
