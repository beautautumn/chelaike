import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Auth from 'models/auth'
import Form from './Form'
import Helmet from 'react-helmet'

@connect(
  _state => ({
    authError: Auth.getState().error,
    logging: Auth.getState().logging,
  })
)
export default class LoginPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    authError: PropTypes.string,
    logging: PropTypes.bool.isRequired,
  }

  componentWillMount() {
    document.body.style.backgroundColor = 'white'
  }

  componentWillUnmount() {
    document.body.style.backgroundColor = null
  }

  handleSubmit = (data) => {
    const { dispatch } = this.props
    dispatch(Auth.login(data))
  }

  render() {
    const { authError, logging } = this.props

    const initialValues = {
      rememberMe: true,
    }

    return (
      <div>
        <Helmet title="登录联盟管理后台" />

        <Form
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
          authError={authError}
          logging={logging}
        />
      </div>
    )
  }
}
