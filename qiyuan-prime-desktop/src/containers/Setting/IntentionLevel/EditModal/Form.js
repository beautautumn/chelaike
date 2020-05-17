import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Field, NumberInput } from 'components'
import validation from './validation'

@reduxForm({
  form: 'intentionLevel',
  fields: ['id', 'name', 'timeLimitation'],
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
          <label htmlFor="name">客户等级</label>
          <input id="name" type="text" {...fields.name} />
        </Field>
        <Field className="required field" {...fields.timeLimitation}>
          <label htmlFor="note">最大跟进间隔天数</label>
          <div className="ui right labeled input">
            <NumberInput id="timeLimitation" {...fields.timeLimitation} />
            <div className="ui label">天</div>
          </div>
        </Field>
      </div>
    )
  }
}
