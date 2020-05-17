import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import validation from './validation'
import { errorFocus } from 'decorators'
import { Segment, Field } from 'components'

@reduxForm({
  form: 'password',
  fields: ['code', 'phone', 'password', 'confirmPassword'],
  validate: validation,
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
  }

  render() {
    const { fields, handleSubmit } = this.props

    return (
      <div>
        {
          fields.code && !fields.code.valid && (
            <div className="ui negative message">
              <div className="header">
                {fields.code.error}
              </div>
            </div>
          )
        }
        <form className="ui form" onSubmit={handleSubmit}>
          <Segment className="ui left aligned segment">
            <Field className="required field" {...fields.password}>
              <label>新密码</label>
              <input type="password" id="password" {...fields.password} />
            </Field>
            <Field className="required field" {...fields.confirmPassword}>
              <label>确认密码</label>
              <input type="password" id="confirmPassword" {...fields.confirmPassword} />
            </Field>
            <button
              className="ui fluid large teal submit button"
              type="submit"
              disabled={!fields.password.value || !fields.confirmPassword.value}
            >
              重置
            </button>
          </Segment>
        </form>
      </div>
    )
  }
}
