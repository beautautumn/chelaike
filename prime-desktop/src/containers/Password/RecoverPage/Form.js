import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'
import validation from './validation'
import { sendCode } from 'redux/modules/password'
import { errorFocus } from 'decorators'
import { Segment, Field } from 'components'

@connect(
  null,
  dispatch => ({
    ...bindActionCreators({ sendCode }, dispatch)
  })
)
@reduxForm({
  form: 'password',
  fields: ['phone', 'code'],
  destroyOnUnmount: false,
  validate: validation,
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    handleNext: PropTypes.func.isRequired,
    sendCode: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)

    this.state = { lock: 0 }
  }

  componentWillUnmount() {
    const { lockInterval } = this.state

    if (lockInterval) {
      clearInterval(lockInterval)
    }
  }

  lockSendCodeButton() {
    this.setState({ lock: 60 })

    const lockInterval = setInterval(() => {
      const { lock } = this.state

      if (lock === 1) {
        clearInterval(lockInterval)
        this.setState({ lock: 0 })
      } else {
        this.setState({ lock: lock - 1 })
      }
    }, 1000)

    this.setState({ lockInterval })
  }

  handleSendCode = (event) => {
    event.preventDefault()

    this.lockSendCodeButton()
    this.props.sendCode(this.props.fields.phone.value)
  }

  next = (event) => {
    event.preventDefault()
    this.props.handleNext()
  }

  render() {
    const { fields } = this.props
    const { lock } = this.state

    return (
      <form className="ui form" >
        <Segment className="ui left aligned segment">
          <Field className="required field" {...fields.phone}>
            <label>手机号码</label>
            <input type="text" id="phone" {...fields.phone} />
          </Field>
          <div className="required field">
            <label>验证码</label>
            <div className="fields">
              <Field className="required code field" {...fields.code}>
                <input type="text" name="code" {...fields.code} />
              </Field>
              <div className="field">
                <button
                  className="ui code button"
                  onClick={this.handleSendCode}
                  disabled={!fields.phone.value || lock !== 0}
                >
                  发送验证码{lock !== 0 && <span>({lock})</span>}
                </button>
              </div>
            </div>
          </div>
          <button
            className="ui fluid large teal submit button"
            disabled={!fields.code.value || !fields.phone.value}
            onClick={this.next}
          >
            下一步
          </button>
        </Segment>
      </form>
    )
  }
}
