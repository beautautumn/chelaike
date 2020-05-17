import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Field } from 'components'
import validation from './validation'

@reduxForm({
  form: 'shop',
  fields: ['id', 'name', 'address', 'phone'],
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
          <label htmlFor="name">分店名称</label>
          <input id="name" type="text" {...fields.name} />
        </Field>
        <Field className="field" {...fields.phone}>
          <label htmlFor="name">联系电话</label>
          <input id="name" type="text" {...fields.phone} />
        </Field>
        <Field className="field" {...fields.address}>
          <label htmlFor="name">分店地址</label>
          <input id="name" type="text" {...fields.address} />
        </Field>
      </div>
    )
  }
}
